/**
 * 이카운트 매출 엑셀 파싱 → 매출자료 자동입력
 *
 * 이카운트 ERP에서 "일별이익현황" 엑셀을 다운로드 받아 업로드하면
 * 거래처그룹1/품목그룹2 기준으로 자동 분류하여 sales_records에 입력
 *
 * 매핑 규칙:
 * ┌──────────┬──────────┬───────────────────────────────────────────────┐
 * │ division │ prodGroup│ 조건                                          │
 * ├──────────┼──────────┼───────────────────────────────────────────────┤
 * │ bombom   │ 본사     │ 거래처그룹1 = "A-1 봄봄 본사"                  │
 * │ bombom   │ 지사     │ 거래처그룹1 = "A-2 봄봄 지사"                  │
 * ├──────────┼──────────┼───────────────────────────────────────────────┤
 * │ online   │ 봄봄     │ 거래처그룹1 = "A-3 봄봄 온라인"               │
 * │ online   │ 슈슈비   │ 거래처그룹1 = "E-2 슈슈비-온라인"              │
 * │ manufact │ 수출     │ 거래처그룹1 = "G. 수출"                        │
 * ├──────────┼──────────┼───────────────────────────────────────────────┤
 * │ manufact │ 리코코   │ 거래처그룹1="B. 매트공급", 품목그룹2 포함 "리코코"│
 * │ manufact │ 크림하우스│ 거래처그룹1="B. 매트공급", 품목그룹2 포함 "크림하우스"│
 * │ manufact │ 에르모어 │ 거래처그룹1="B. 매트공급", 품목그룹2 포함 "링크맘"│
 * │ manufact │ 기타     │ B. 매트공급 계 - 리코코 - 크림하우스 - 에르모어  │
 * └──────────┴──────────┴───────────────────────────────────────────────┘
 */

import type { Express, Request, Response } from "express";
import multer from "multer";
import XLSX from "xlsx";
import { v4 as uuidv4 } from "uuid";
import mysql from "mysql2/promise";

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } });

interface ParsedRow {
  custGroup: string;   // 거래처그룹1 (col 0)
  prodGroup: string;   // 품목그룹2 (col 1)
  salesAmount: number; // 판매액 (col 3)
}

interface SalesEntry {
  division: string;
  productGroup: string;
  salesAmount: number;
}

/**
 * 엑셀에서 "계" 행의 판매액을 거래처그룹별로 추출
 */
function parseEcountExcel(buffer: Buffer): ParsedRow[] {
  const wb = XLSX.read(buffer, { type: "buffer" });
  const sheet = wb.Sheets[wb.SheetNames[0]];
  const data: any[][] = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });

  const rows: ParsedRow[] = [];
  let currentCustGroup = "";

  for (const row of data) {
    const col0 = String(row[0] ?? "").trim();
    const col1 = String(row[1] ?? "").trim();
    const col3 = row[3]; // 판매액 (당월)

    // 거래처그룹이 있는 행 (비어있지 않고 "계"가 아닌 경우)
    if (col0 && !col0.includes("계") && !col0.includes("합계") && !col0.startsWith("회사명") && !col0.includes("2026/")) {
      currentCustGroup = col0;
    }

    // "계" 행 → 해당 거래처그룹의 합계
    if (col0.endsWith("계") && !col0.includes("합계")) {
      const amount = typeof col3 === "number" ? col3 : parseFloat(String(col3 ?? "0")) || 0;
      rows.push({
        custGroup: currentCustGroup || col0.replace(/\s*계$/, ""),
        prodGroup: "합계",
        salesAmount: amount,
      });
    }

    // 개별 품목그룹 행 (거래처그룹이 있거나 현재 그룹 소속)
    if (currentCustGroup && col1 && !col1.includes("NaN") && col1 !== "NaN" && col3 != null) {
      const amount = typeof col3 === "number" ? col3 : parseFloat(String(col3 ?? "0")) || 0;
      rows.push({
        custGroup: currentCustGroup,
        prodGroup: col1,
        salesAmount: amount,
      });
    }
  }

  return rows;
}

/**
 * 파싱된 행을 매핑 규칙에 따라 매출 항목으로 변환
 */
function mapToSalesEntries(rows: ParsedRow[]): SalesEntry[] {
  const entries: SalesEntry[] = [];

  // 거래처그룹별 "계" 행 판매액 추출
  const groupTotals: Record<string, number> = {};
  // 개별 품목 판매액
  const itemSales: Record<string, Record<string, number>> = {};

  for (const row of rows) {
    const key = row.custGroup.toUpperCase().replace(/\s+/g, "");

    if (row.prodGroup === "합계") {
      groupTotals[key] = row.salesAmount;
    } else {
      if (!itemSales[key]) itemSales[key] = {};
      itemSales[key][row.prodGroup] = row.salesAmount;
    }
  }

  // ─── 봄봄시공 (bombom) ───
  for (const [key, amount] of Object.entries(groupTotals)) {
    if (key.includes("A-1") || key.includes("봄봄본사")) {
      entries.push({ division: "bombom", productGroup: "본사", salesAmount: amount });
    }
    if (key.includes("A-2") || key.includes("봄봄지사")) {
      entries.push({ division: "bombom", productGroup: "지사", salesAmount: amount });
    }
  }

  // ─── 온라인판매 (online) ───
  for (const [key, amount] of Object.entries(groupTotals)) {
    if (key.includes("A-3") || key.includes("봄봄온라인")) {
      entries.push({ division: "online", productGroup: "봄봄", salesAmount: amount });
    }
    if (key.includes("E-2") || key.includes("슈슈비")) {
      entries.push({ division: "online", productGroup: "슈슈비", salesAmount: amount });
    }
    // G. 수출은 manufacturing(제조공급)으로 분류 - 아래 제조공급 섹션에서 처리
  }

  // ─── 제조공급 (manufacturing) ───
  // B. 매트공급 내 품목별 분류
  const matItems = itemSales["B.매트공급"] || itemSales["B.매트공급"] || {};
  // 모든 "B. 매트공급" 관련 키를 찾기
  let matKey = "";
  for (const k of Object.keys(itemSales)) {
    if (k.includes("B.") || k.includes("매트공급")) {
      matKey = k;
      break;
    }
  }
  const matItemsResolved = matKey ? itemSales[matKey] || {} : {};

  let ricocoAmt = 0;
  let creamhouseAmt = 0;
  let ermoreAmt = 0;

  for (const [prodName, amount] of Object.entries(matItemsResolved)) {
    if (prodName.includes("리코코")) ricocoAmt += amount;
    else if (prodName.includes("크림하우스")) creamhouseAmt += amount;
    else if (prodName.includes("링크맘")) ermoreAmt += amount;
  }

  // B. 매트공급 계
  let matTotal = 0;
  for (const [key, amount] of Object.entries(groupTotals)) {
    if (key.includes("B.") || key.includes("매트공급")) {
      matTotal = amount;
      break;
    }
  }

  // G. 수출 → 제조공급 / 거래처명 = 수출
  let exportAmt = 0;
  for (const [key, amount] of Object.entries(groupTotals)) {
    if (key.includes('G.') || (key.includes('수출') && !key.includes('봄봄') && !key.includes('A-'))) {
      exportAmt += amount;
    }
  }
  entries.push({ division: 'manufacturing', productGroup: '수출', salesAmount: exportAmt });
  entries.push({ division: "manufacturing", productGroup: "리코코", salesAmount: ricocoAmt });
  entries.push({ division: "manufacturing", productGroup: "크림하우스", salesAmount: creamhouseAmt });
  entries.push({ division: "manufacturing", productGroup: "에르모어", salesAmount: ermoreAmt });
  entries.push({
    division: "manufacturing",
    productGroup: "기타",
    salesAmount: matTotal - ricocoAmt - creamhouseAmt - ermoreAmt,
  });

  return entries;
}

/**
 * 엑셀 헤더에서 날짜 범위를 파싱하여 연/월 추출
 */
function parseDateFromExcel(buffer: Buffer): { year: number; month: number } {
  const wb = XLSX.read(buffer, { type: "buffer" });
  const sheet = wb.Sheets[wb.SheetNames[0]];
  const data: any[][] = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });

  // 첫 행: "회사명 : 주식회사 옥토아이앤씨 / 2026/03/01  ~ 2026/03/31"
  const header = String(data[0]?.[0] ?? "");
  const match = header.match(/(\d{4})\/(\d{2})\/\d{2}\s*~\s*\d{4}\/\d{2}\/\d{2}/);
  if (match) {
    return { year: parseInt(match[1]), month: parseInt(match[2]) };
  }

  // 대체: 현재 날짜
  const now = new Date();
  return { year: now.getFullYear(), month: now.getMonth() + 1 };
}

/**
 * 주차 결정 (매월 몇 주차인지)
 */
function getCurrentWeek(): number {
  const now = new Date();
  const day = now.getDate();
  if (day <= 7) return 1;
  if (day <= 14) return 2;
  if (day <= 21) return 3;
  if (day <= 28) return 4;
  return 5;
}

/**
 * Express 라우트 등록
 */
export function registerEcountRoutes(app: Express) {
  // 엑셀 업로드 → 미리보기 (파싱 결과 확인)
  app.post("/api/ecount/preview", upload.single("file"), async (req: Request, res: Response) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "파일이 없습니다" });
      }

      const rows = parseEcountExcel(req.file.buffer);
      const entries = mapToSalesEntries(rows);
      const { year, month } = parseDateFromExcel(req.file.buffer);
      const week = getCurrentWeek();

      res.json({
        success: true,
        year,
        month,
        currentWeek: week,
        entries: entries.map((e) => ({
          ...e,
          salesAmount: Math.round(e.salesAmount),
          salesAmountFormatted: new Intl.NumberFormat("ko-KR").format(Math.round(e.salesAmount)),
        })),
        rawRowCount: rows.length,
      });
    } catch (error) {
      console.error("[Ecount] 엑셀 파싱 실패:", error);
      res.status(500).json({ error: "엑셀 파싱에 실패했습니다: " + (error as Error).message });
    }
  });

  // 엑셀 업로드 → DB 저장 (자동입력 실행)
  app.post("/api/ecount/import", upload.single("file"), async (req: Request, res: Response) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "파일이 없습니다" });
      }

      const rows = parseEcountExcel(req.file.buffer);
      const entries = mapToSalesEntries(rows);
      const { year, month } = parseDateFromExcel(req.file.buffer);
      const weekNum = parseInt(req.body.week || String(getCurrentWeek()));
      const weekField = `week${weekNum}Sales`;

      if (weekNum < 1 || weekNum > 5) {
        return res.status(400).json({ error: "주차는 1~5 사이여야 합니다" });
      }

      const dbUrl = process.env.DATABASE_URL;
      if (!dbUrl) {
        return res.status(500).json({ error: "DATABASE_URL이 설정되지 않았습니다" });
      }

      const conn = await mysql.createConnection(dbUrl);
      let upserted = 0;

      try {
        for (const entry of entries) {
          const id = uuidv4();
          // UPSERT: division + productGroup + year + month 기준
          await conn.execute(
            `INSERT INTO sales_records (id, userId, division, productGroup, ${weekField}, cumulativeSales, year, month, createdAt, updatedAt)
             VALUES (?, 1, ?, ?, ?, ?, ?, ?, NOW(), NOW())
             ON DUPLICATE KEY UPDATE
               ${weekField} = VALUES(${weekField}),
               cumulativeSales = VALUES(cumulativeSales),
               updatedAt = NOW()`,
            [id, entry.division, entry.productGroup, Math.round(entry.salesAmount), Math.round(entry.salesAmount), year, month]
          );
          upserted++;
        }

        // cumulativeSales 업데이트 (week1~5 합계)
        await conn.execute(
          `UPDATE sales_records
           SET cumulativeSales = COALESCE(week1Sales, 0) + COALESCE(week2Sales, 0) + COALESCE(week3Sales, 0) + COALESCE(week4Sales, 0) + COALESCE(week5Sales, 0),
               achievementRate = CASE WHEN monthlyTarget > 0 THEN ROUND((COALESCE(week1Sales, 0) + COALESCE(week2Sales, 0) + COALESCE(week3Sales, 0) + COALESCE(week4Sales, 0) + COALESCE(week5Sales, 0)) / monthlyTarget * 100, 1) ELSE 0 END,
               updatedAt = NOW()
           WHERE year = ? AND month = ?`,
          [year, month]
        );
      } finally {
        await conn.end();
      }

      res.json({
        success: true,
        year,
        month,
        week: weekNum,
        entriesCount: upserted,
        entries: entries.map((e) => ({
          division: e.division,
          productGroup: e.productGroup,
          salesAmount: Math.round(e.salesAmount),
        })),
      });
    } catch (error) {
      console.error("[Ecount] 매출 자동입력 실패:", error);
      res.status(500).json({ error: "매출 자동입력에 실패했습니다: " + (error as Error).message });
    }
  });
}
