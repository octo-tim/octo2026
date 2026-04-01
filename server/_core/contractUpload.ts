/**
 * 채널별실적 엑셀 업로드 → 계약현황 자동입력
 *
 * 엑셀 형식:
 * Row 0: [ 채널별실적 (산출기간:2026-03-01 ~ 2026-03-08) ]
 * Row 1: (header)  실적
 * Row 2: 기준 | 구분 | 유입 | 예약 | %
 * Row 3~N: 유입채널 | 채널명 | 유입수 | 예약수 | 전환율
 * Last:   유입채널 | 채널합계 | ...
 *
 * 매핑: 채널명 → 내부채널/외부채널 + subChannel
 * 값: "예약" 컬럼 → weekNCount (주차별 계약 건수)
 */

import type { Express, Request, Response } from "express";
import multer from "multer";
import XLSX from "xlsx";
import { v4 as uuidv4 } from "uuid";
import mysql from "mysql2/promise";

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } });

// ── 채널 매핑: 엑셀 채널명 → { channel, subChannel } ──────────
const CHANNEL_MAP: Record<string, { channel: string; subChannel: string }> = {
  // 내부채널
  '상담전화': { channel: '내부채널', subChannel: '상담전화' },
  '샘플신청': { channel: '내부채널', subChannel: '샘플신청' },
  '채널톡': { channel: '내부채널', subChannel: '채널톡' },
  '홈피문의': { channel: '내부채널', subChannel: '홈피문의' },
  // 외부채널
  '공구진행': { channel: '외부채널', subChannel: '공구진행' },
  '구루구루': { channel: '외부채널', subChannel: '구루구루' },
  '기타': { channel: '외부채널', subChannel: '기타' },
  '꿈비': { channel: '외부채널', subChannel: '꿈비' },
  '라이브커머스': { channel: '외부채널', subChannel: '라이브커머스' },
  '링크맘': { channel: '외부채널', subChannel: '링크맘' },
  '베이비페어': { channel: '외부채널', subChannel: '베이비페어' },
  '베이비페어(꿈비)': { channel: '외부채널', subChannel: '베이비페어(꿈비)' },
  '숨고': { channel: '외부채널', subChannel: '숨고' },
  '시공팀자체영업': { channel: '외부채널', subChannel: '시공팀자체영업' },
  '시공팀': { channel: '외부채널', subChannel: '시공팀자체영업' }, // alias
  '유아매장': { channel: '외부채널', subChannel: '유아매장' },
  '인플루언서공구': { channel: '외부채널', subChannel: '인플루언서공구' },
  '입주박람회': { channel: '외부채널', subChannel: '입주박람회' },
  '쥬다르': { channel: '외부채널', subChannel: '쥬다르' },
  '지사자체상담': { channel: '외부채널', subChannel: '지사자체상담' },
};

interface ParsedChannel {
  excelName: string;     // 엑셀에 표시된 채널명
  channel: string;       // 내부채널 or 외부채널
  subChannel: string;    // 세부 채널명
  inflow: number;        // 유입
  reservation: number;   // 예약
  conversionRate: number; // 전환율 %
  mapped: boolean;       // 매핑 성공 여부
}

interface ParseResult {
  year: number;
  month: number;
  startDate: string;
  endDate: string;
  channels: ParsedChannel[];
  totalInflow: number;
  totalReservation: number;
}

/**
 * 산출기간에서 날짜 추출
 * "[ 채널별실적 (산출기간:2026-03-01 ~ 2026-03-08) ]"
 */
function parsePeriod(title: string): { year: number; month: number; startDate: string; endDate: string } {
  const match = title.match(/산출기간\s*:\s*(\d{4}-\d{2}-\d{2})\s*~\s*(\d{4}-\d{2}-\d{2})/);
  if (!match) {
    throw new Error("산출기간을 파싱할 수 없습니다. 형식: (산출기간:YYYY-MM-DD ~ YYYY-MM-DD)");
  }
  const startDate = match[1];
  const endDate = match[2];
  const [yearStr, monthStr] = startDate.split("-");
  return {
    year: parseInt(yearStr),
    month: parseInt(monthStr),
    startDate,
    endDate,
  };
}

/**
 * 시작일 기준으로 해당 월의 몇 주차인지 계산
 */
function calculateWeek(startDate: string): number {
  const day = parseInt(startDate.split("-")[2]);
  if (day <= 7) return 1;
  if (day <= 14) return 2;
  if (day <= 21) return 3;
  if (day <= 28) return 4;
  return 5;
}

/**
 * 엑셀 파싱
 */
function parseContractExcel(buffer: Buffer): ParseResult {
  const wb = XLSX.read(buffer, { type: "buffer" });
  const sheet = wb.Sheets[wb.SheetNames[0]];
  const rows: any[][] = XLSX.utils.sheet_to_json(sheet, { header: 1 });

  if (rows.length < 4) {
    throw new Error("엑셀 데이터가 부족합니다 (최소 4행 필요)");
  }

  // Row 0: 제목 (산출기간)
  const titleRow = rows[0];
  const titleStr = String(titleRow[0] || "");
  const { year, month, startDate, endDate } = parsePeriod(titleStr);

  // Row 3 이후: 데이터
  const channels: ParsedChannel[] = [];
  let totalInflow = 0;
  let totalReservation = 0;

  for (let i = 3; i < rows.length; i++) {
    const row = rows[i];
    if (!row || !row[1]) continue;

    const channelName = String(row[1]).trim();

    // 합계 행 스킵
    if (channelName === '채널합계') {
      totalInflow = Number(row[2]) || 0;
      totalReservation = Number(row[3]) || 0;
      continue;
    }

    const inflow = Number(row[2]) || 0;
    const reservation = Number(row[3]) || 0;
    const conversionRate = Number(row[4]) || 0;

    const mapping = CHANNEL_MAP[channelName];
    if (mapping) {
      channels.push({
        excelName: channelName,
        channel: mapping.channel,
        subChannel: mapping.subChannel,
        inflow,
        reservation,
        conversionRate,
        mapped: true,
      });
    } else {
      // 매핑 안 되는 채널은 외부채널로 분류
      channels.push({
        excelName: channelName,
        channel: '외부채널',
        subChannel: channelName,
        inflow,
        reservation,
        conversionRate,
        mapped: false,
      });
    }
  }

  return { year, month, startDate, endDate, channels, totalInflow, totalReservation };
}

/**
 * Express 라우트 등록
 */
export function registerContractUploadRoutes(app: Express) {
  // 미리보기 (파싱 결과 확인)
  app.post("/api/contract/upload/preview", upload.single("file"), async (req: Request, res: Response) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "파일이 없습니다" });
      }

      const result = parseContractExcel(req.file.buffer);
      const week = calculateWeek(result.startDate);

      res.json({
        success: true,
        year: result.year,
        month: result.month,
        startDate: result.startDate,
        endDate: result.endDate,
        week,
        channels: result.channels,
        totalInflow: result.totalInflow,
        totalReservation: result.totalReservation,
        channelCount: result.channels.length,
        unmappedCount: result.channels.filter(c => !c.mapped).length,
      });
    } catch (error) {
      console.error("[ContractUpload] 엑셀 파싱 실패:", error);
      res.status(500).json({ error: "엑셀 파싱에 실패했습니다: " + (error as Error).message });
    }
  });

  // DB 저장 (자동입력 실행)
  app.post("/api/contract/upload/import", upload.single("file"), async (req: Request, res: Response) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "파일이 없습니다" });
      }

      const result = parseContractExcel(req.file.buffer);
      const weekNum = parseInt(req.body.week || String(calculateWeek(result.startDate)));
      const brand = req.body.brand || 'bombom';

      if (weekNum < 1 || weekNum > 5) {
        return res.status(400).json({ error: "주차는 1~5 사이여야 합니다" });
      }

      const weekField = `week${weekNum}Count`;

      const dbUrl = process.env.DATABASE_URL;
      if (!dbUrl) {
        return res.status(500).json({ error: "DATABASE_URL이 설정되지 않았습니다" });
      }

      const conn = await mysql.createConnection(dbUrl);
      let upserted = 0;
      const importedChannels: { channel: string; subChannel: string; reservation: number }[] = [];

      try {
        for (const ch of result.channels) {
          // 예약 값이 0이어도 저장 (모든 채널 기록 유지)
          const id = uuidv4();
          
          await conn.execute(
            `INSERT INTO contract_records (id, userId, brand, channel, subChannel, ${weekField}, totalCount, year, month, createdAt, updatedAt)
             VALUES (?, 1, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
             ON DUPLICATE KEY UPDATE
               ${weekField} = VALUES(${weekField}),
               totalCount = COALESCE(week1Count, 0) + COALESCE(week2Count, 0) + COALESCE(week3Count, 0) + COALESCE(week4Count, 0) + COALESCE(week5Count, 0),
               updatedAt = NOW()`,
            [id, brand, ch.channel, ch.subChannel, ch.reservation, ch.reservation, result.year, result.month]
          );
          upserted++;
          importedChannels.push({
            channel: ch.channel,
            subChannel: ch.subChannel,
            reservation: ch.reservation,
          });
        }

        // totalCount + achievementRate 전체 재계산
        await conn.execute(
          `UPDATE contract_records
           SET totalCount = COALESCE(week1Count, 0) + COALESCE(week2Count, 0) + COALESCE(week3Count, 0) + COALESCE(week4Count, 0) + COALESCE(week5Count, 0),
               achievementRate = CASE WHEN monthlyTarget > 0 THEN ROUND((COALESCE(week1Count, 0) + COALESCE(week2Count, 0) + COALESCE(week3Count, 0) + COALESCE(week4Count, 0) + COALESCE(week5Count, 0)) / monthlyTarget * 100, 1) ELSE 0 END,
               updatedAt = NOW()
           WHERE year = ? AND month = ? AND brand = ?`,
          [result.year, result.month, brand]
        );
      } finally {
        await conn.end();
      }

      res.json({
        success: true,
        year: result.year,
        month: result.month,
        week: weekNum,
        brand,
        entriesCount: upserted,
        channels: importedChannels,
      });
    } catch (error) {
      console.error("[ContractUpload] 계약현황 자동입력 실패:", error);
      res.status(500).json({ error: "계약현황 자동입력에 실패했습니다: " + (error as Error).message });
    }
  });
}
