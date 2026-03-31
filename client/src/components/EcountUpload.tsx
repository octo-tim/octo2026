/**
 * 이카운트 매출 엑셀 업로드 + 입력규칙 관리 컴포넌트
 */
import { useState, useRef } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { toast } from 'sonner';
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription,
} from '@/components/ui/dialog';
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from '@/components/ui/table';
import { Upload, FileSpreadsheet, Loader2, Settings2, Pencil, Trash2, Plus, Save, AlertCircle, CheckCircle2 } from 'lucide-react';

// ── 입력규칙 타입 ────────────────────────────────────────────
export interface MappingRule {
  division: string;         // bombom, online, manufacturing
  divisionLabel: string;    // 봄봄시공, 온라인판매, 제조공급
  productGroup: string;     // 본사, 지사, 봄봄, 슈슈비, ...
  condition: string;        // 거래처그룹1 조건 (예: "A-1 봄봄 본사")
  conditionType: 'custGroup' | 'custGroupAndProd'; // custGroup: 거래처그룹 계, custGroupAndProd: 거래처그룹+품목그룹
  prodCondition?: string;   // 품목그룹2 조건 (conditionType이 custGroupAndProd일 때)
  isRemainder?: boolean;    // "기타" = 해당 division 전체 - 다른 규칙 합계
}

// 기본 입력규칙
const DEFAULT_RULES: MappingRule[] = [
  // 봄봄시공
  { division: 'bombom', divisionLabel: '봄봄시공', productGroup: '본사', condition: 'A-1 봄봄 본사', conditionType: 'custGroup' },
  { division: 'bombom', divisionLabel: '봄봄시공', productGroup: '지사', condition: 'A-2 봄봄 지사', conditionType: 'custGroup' },
  // 온라인판매
  { division: 'online', divisionLabel: '온라인판매', productGroup: '봄봄', condition: 'A-3 봄봄 온라인', conditionType: 'custGroup' },
  { division: 'online', divisionLabel: '온라인판매', productGroup: '슈슈비', condition: 'E-2 슈슈비-온라인', conditionType: 'custGroup' },
  { division: 'online', divisionLabel: '온라인판매', productGroup: '기타', condition: 'G. 수출', conditionType: 'custGroup' },
  // 제조공급
  { division: 'manufacturing', divisionLabel: '제조공급', productGroup: '리코코', condition: 'B. 매트공급', conditionType: 'custGroupAndProd', prodCondition: '리코코' },
  { division: 'manufacturing', divisionLabel: '제조공급', productGroup: '크림하우스', condition: 'B. 매트공급', conditionType: 'custGroupAndProd', prodCondition: '크림하우스' },
  { division: 'manufacturing', divisionLabel: '제조공급', productGroup: '에르모어', condition: 'B. 매트공급', conditionType: 'custGroupAndProd', prodCondition: '링크맘' },
  { division: 'manufacturing', divisionLabel: '제조공급', productGroup: '기타', condition: 'B. 매트공급', conditionType: 'custGroup', isRemainder: true },
];

// localStorage 키
const RULES_STORAGE_KEY = 'ecount-mapping-rules';

function loadRules(): MappingRule[] {
  try {
    const saved = localStorage.getItem(RULES_STORAGE_KEY);
    if (saved) return JSON.parse(saved);
  } catch { /* ignore */ }
  return DEFAULT_RULES;
}

function saveRules(rules: MappingRule[]) {
  localStorage.setItem(RULES_STORAGE_KEY, JSON.stringify(rules));
}

// ── 미리보기 결과 타입 ───────────────────────────────────────
interface PreviewEntry {
  division: string;
  productGroup: string;
  salesAmount: number;
  salesAmountFormatted: string;
}

interface PreviewResult {
  success: boolean;
  year: number;
  month: number;
  currentWeek: number;
  entries: PreviewEntry[];
  rawRowCount: number;
}

const formatNumber = (num: number): string => new Intl.NumberFormat('ko-KR').format(num);

const DIVISION_OPTIONS = [
  { value: 'bombom', label: '봄봄시공' },
  { value: 'online', label: '온라인판매' },
  { value: 'manufacturing', label: '제조공급' },
  { value: 'ricoco', label: '리코코' },
];

// ── 엑셀 업로드 컴포넌트 ────────────────────────────────────
export function EcountUpload({ year, month, onImportSuccess }: {
  year: number;
  month: number;
  onImportSuccess: () => void;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [isRulesOpen, setIsRulesOpen] = useState(false);
  const [selectedWeek, setSelectedWeek] = useState('1');
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<PreviewResult | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const [importResult, setImportResult] = useState<{ success: boolean; message: string } | null>(null);
  const fileRef = useRef<HTMLInputElement>(null);

  // 입력규칙 관리
  const [rules, setRules] = useState<MappingRule[]>(loadRules);
  const [editingRule, setEditingRule] = useState<MappingRule | null>(null);
  const [editingIndex, setEditingIndex] = useState<number | null>(null);

  // 현재 주차 자동 계산
  const getCurrentWeek = () => {
    const day = new Date().getDate();
    if (day <= 7) return '1';
    if (day <= 14) return '2';
    if (day <= 21) return '3';
    if (day <= 28) return '4';
    return '5';
  };

  const handleOpen = () => {
    setSelectedWeek(getCurrentWeek());
    setFile(null);
    setPreview(null);
    setImportResult(null);
    setIsOpen(true);
  };

  // 파일 선택 시 미리보기
  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const f = e.target.files?.[0];
    if (!f) return;
    setFile(f);
    setPreview(null);
    setImportResult(null);
    setIsLoading(true);

    try {
      const formData = new FormData();
      formData.append('file', f);
      const res = await fetch('/api/ecount/preview', { method: 'POST', body: formData });
      const data = await res.json();
      if (data.success) {
        setPreview(data);
      } else {
        toast.error(data.error || '파싱 실패');
      }
    } catch (err) {
      toast.error('파일 업로드 중 오류가 발생했습니다');
    } finally {
      setIsLoading(false);
    }
  };

  // 자동입력 실행
  const handleImport = async () => {
    if (!file) return;
    setIsImporting(true);
    setImportResult(null);

    try {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('week', selectedWeek);
      const res = await fetch('/api/ecount/import', { method: 'POST', body: formData });
      const data = await res.json();
      if (data.success) {
        setImportResult({ success: true, message: `${data.entriesCount}개 항목이 ${data.week}주차에 입력되었습니다.` });
        toast.success(`매출 자동입력 완료 (${data.entriesCount}개 항목, ${data.week}주차)`);
        onImportSuccess();
      } else {
        setImportResult({ success: false, message: data.error || '입력 실패' });
        toast.error(data.error || '자동입력 실패');
      }
    } catch (err) {
      setImportResult({ success: false, message: '서버 오류' });
      toast.error('자동입력 중 오류가 발생했습니다');
    } finally {
      setIsImporting(false);
    }
  };

  // ── 입력규칙 관리 ──────────────────────────────────────────
  const handleAddRule = () => {
    setEditingRule({
      division: 'bombom',
      divisionLabel: '봄봄시공',
      productGroup: '',
      condition: '',
      conditionType: 'custGroup',
    });
    setEditingIndex(null);
  };

  const handleEditRule = (index: number) => {
    setEditingRule({ ...rules[index] });
    setEditingIndex(index);
  };

  const handleDeleteRule = (index: number) => {
    const updated = rules.filter((_, i) => i !== index);
    setRules(updated);
    saveRules(updated);
    toast.success('규칙이 삭제되었습니다');
  };

  const handleSaveRule = () => {
    if (!editingRule || !editingRule.productGroup || !editingRule.condition) {
      toast.error('모든 필드를 입력해주세요');
      return;
    }
    const divOption = DIVISION_OPTIONS.find(d => d.value === editingRule.division);
    const rule = { ...editingRule, divisionLabel: divOption?.label || editingRule.division };

    let updated: MappingRule[];
    if (editingIndex !== null) {
      updated = [...rules];
      updated[editingIndex] = rule;
    } else {
      updated = [...rules, rule];
    }
    setRules(updated);
    saveRules(updated);
    setEditingRule(null);
    setEditingIndex(null);
    toast.success('규칙이 저장되었습니다');
  };

  const handleResetRules = () => {
    setRules(DEFAULT_RULES);
    saveRules(DEFAULT_RULES);
    toast.success('기본 규칙으로 초기화되었습니다');
  };

  return (
    <>
      {/* 업로드 버튼 */}
      <div className="flex gap-2">
        <Button variant="outline" size="sm" onClick={handleOpen}>
          <Upload className="h-4 w-4 mr-1.5" />
          이카운트 매출 업로드
        </Button>
        <Button variant="ghost" size="sm" onClick={() => setIsRulesOpen(true)} title="입력규칙 관리">
          <Settings2 className="h-4 w-4" />
        </Button>
      </div>

      {/* ── 엑셀 업로드 모달 ─────────────────────────────────── */}
      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <FileSpreadsheet className="h-5 w-5 text-green-600" />
              이카운트 매출 자동입력
            </DialogTitle>
            <DialogDescription>
              이카운트 ERP의 "일별이익현황" 엑셀 파일을 업로드하면 매핑 규칙에 따라 자동으로 매출 데이터를 입력합니다.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-5">
            {/* 주차 선택 */}
            <div className="flex items-center gap-4">
              <Label className="min-w-[60px] font-semibold">입력 주차</Label>
              <Select value={selectedWeek} onValueChange={setSelectedWeek}>
                <SelectTrigger className="w-[140px]">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="1">1주차 (1~7일)</SelectItem>
                  <SelectItem value="2">2주차 (8~14일)</SelectItem>
                  <SelectItem value="3">3주차 (15~21일)</SelectItem>
                  <SelectItem value="4">4주차 (22~28일)</SelectItem>
                  <SelectItem value="5">5주차 (29~말일)</SelectItem>
                </SelectContent>
              </Select>
              <span className="text-sm text-muted-foreground">
                {year}년 {month}월 {selectedWeek}주차에 입력됩니다
              </span>
            </div>

            {/* 파일 업로드 */}
            <div className="border-2 border-dashed border-muted-foreground/25 rounded-xl p-6 text-center hover:border-primary/50 transition-colors">
              <input
                ref={fileRef}
                type="file"
                accept=".xlsx,.xls"
                onChange={handleFileChange}
                className="hidden"
              />
              {file ? (
                <div className="flex items-center justify-center gap-3">
                  <FileSpreadsheet className="h-8 w-8 text-green-600" />
                  <div className="text-left">
                    <p className="font-medium">{file.name}</p>
                    <p className="text-sm text-muted-foreground">{(file.size / 1024).toFixed(1)} KB</p>
                  </div>
                  <Button variant="ghost" size="sm" onClick={() => { setFile(null); setPreview(null); if (fileRef.current) fileRef.current.value = ''; }}>
                    변경
                  </Button>
                </div>
              ) : (
                <div className="space-y-2">
                  <Upload className="h-10 w-10 mx-auto text-muted-foreground/50" />
                  <p className="text-muted-foreground">이카운트 "일별이익현황" 엑셀 파일을 선택하세요</p>
                  <Button variant="outline" onClick={() => fileRef.current?.click()}>
                    파일 선택
                  </Button>
                </div>
              )}
            </div>

            {/* 로딩 */}
            {isLoading && (
              <div className="flex items-center justify-center gap-2 py-4">
                <Loader2 className="h-5 w-5 animate-spin" />
                <span>엑셀 파일 분석 중...</span>
              </div>
            )}

            {/* 미리보기 */}
            {preview && (
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <h3 className="font-semibold text-sm">미리보기 ({preview.entries.length}개 항목)</h3>
                  <span className="text-xs text-muted-foreground">
                    {preview.year}년 {preview.month}월 데이터
                  </span>
                </div>
                <div className="rounded-lg border overflow-hidden">
                  <Table>
                    <TableHeader>
                      <TableRow className="bg-muted/50">
                        <TableHead className="w-[100px]">사업부</TableHead>
                        <TableHead className="w-[100px]">제품그룹</TableHead>
                        <TableHead className="text-right">판매액</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {preview.entries.map((entry, idx) => {
                        const divLabel = DIVISION_OPTIONS.find(d => d.value === entry.division)?.label || entry.division;
                        return (
                          <TableRow key={idx}>
                            <TableCell className="text-sm">{divLabel}</TableCell>
                            <TableCell className="text-sm font-medium">{entry.productGroup}</TableCell>
                            <TableCell className="text-right font-mono text-sm">{entry.salesAmountFormatted}</TableCell>
                          </TableRow>
                        );
                      })}
                    </TableBody>
                  </Table>
                </div>
              </div>
            )}

            {/* 결과 */}
            {importResult && (
              <div className={`flex items-center gap-2 p-3 rounded-lg ${importResult.success ? 'bg-green-50 text-green-700 border border-green-200' : 'bg-red-50 text-red-700 border border-red-200'}`}>
                {importResult.success ? <CheckCircle2 className="h-5 w-5" /> : <AlertCircle className="h-5 w-5" />}
                <span className="text-sm font-medium">{importResult.message}</span>
              </div>
            )}
          </div>

          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setIsOpen(false)}>닫기</Button>
            <Button
              onClick={handleImport}
              disabled={!preview || isImporting}
              className="bg-green-600 hover:bg-green-700"
            >
              {isImporting ? <Loader2 className="h-4 w-4 mr-2 animate-spin" /> : <Upload className="h-4 w-4 mr-2" />}
              {selectedWeek}주차에 자동입력
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* ── 입력규칙 관리 모달 ────────────────────────────────── */}
      <Dialog open={isRulesOpen} onOpenChange={setIsRulesOpen}>
        <DialogContent className="max-w-3xl max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Settings2 className="h-5 w-5" />
              매출 자동입력 규칙 관리
            </DialogTitle>
            <DialogDescription>
              이카운트 엑셀의 거래처그룹1/품목그룹2를 매출관리 사업부/제품그룹으로 매핑하는 규칙입니다.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4">
            {/* 규칙 테이블 */}
            <div className="rounded-lg border overflow-hidden">
              <Table>
                <TableHeader>
                  <TableRow className="bg-muted/50">
                    <TableHead className="w-[90px]">사업부</TableHead>
                    <TableHead className="w-[80px]">제품그룹</TableHead>
                    <TableHead>매핑 조건</TableHead>
                    <TableHead className="w-[80px] text-center">작업</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {rules.map((rule, idx) => (
                    <TableRow key={idx}>
                      <TableCell className="text-sm">{rule.divisionLabel}</TableCell>
                      <TableCell className="text-sm font-medium">{rule.productGroup}</TableCell>
                      <TableCell className="text-sm text-muted-foreground">
                        {rule.isRemainder ? (
                          <span className="text-amber-600">{rule.condition} 계 - 다른 규칙 합계</span>
                        ) : rule.conditionType === 'custGroupAndProd' ? (
                          <span>거래처그룹1 = "{rule.condition}" + 품목그룹2 포함 "{rule.prodCondition}"</span>
                        ) : (
                          <span>거래처그룹1 = "{rule.condition}" 계</span>
                        )}
                      </TableCell>
                      <TableCell className="text-center">
                        <div className="flex items-center justify-center gap-1">
                          <Button variant="ghost" size="sm" onClick={() => handleEditRule(idx)}>
                            <Pencil className="h-3.5 w-3.5" />
                          </Button>
                          <Button variant="ghost" size="sm" className="text-destructive" onClick={() => handleDeleteRule(idx)}>
                            <Trash2 className="h-3.5 w-3.5" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>

            {/* 규칙 편집 폼 */}
            {editingRule && (
              <div className="p-4 border rounded-lg bg-muted/20 space-y-3">
                <h4 className="font-semibold text-sm">{editingIndex !== null ? '규칙 수정' : '새 규칙 추가'}</h4>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <Label className="text-xs">사업부</Label>
                    <Select value={editingRule.division} onValueChange={(v) => setEditingRule({ ...editingRule, division: v })}>
                      <SelectTrigger><SelectValue /></SelectTrigger>
                      <SelectContent>
                        {DIVISION_OPTIONS.map(d => <SelectItem key={d.value} value={d.value}>{d.label}</SelectItem>)}
                      </SelectContent>
                    </Select>
                  </div>
                  <div>
                    <Label className="text-xs">제품그룹명</Label>
                    <Input value={editingRule.productGroup} onChange={(e) => setEditingRule({ ...editingRule, productGroup: e.target.value })} placeholder="예: 본사, 리코코" />
                  </div>
                  <div>
                    <Label className="text-xs">조건 유형</Label>
                    <Select value={editingRule.conditionType} onValueChange={(v: 'custGroup' | 'custGroupAndProd') => setEditingRule({ ...editingRule, conditionType: v })}>
                      <SelectTrigger><SelectValue /></SelectTrigger>
                      <SelectContent>
                        <SelectItem value="custGroup">거래처그룹1 "계" 행</SelectItem>
                        <SelectItem value="custGroupAndProd">거래처그룹1 + 품목그룹2</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div>
                    <Label className="text-xs">거래처그룹1 조건</Label>
                    <Input value={editingRule.condition} onChange={(e) => setEditingRule({ ...editingRule, condition: e.target.value })} placeholder="예: A-1 봄봄 본사" />
                  </div>
                  {editingRule.conditionType === 'custGroupAndProd' && (
                    <div>
                      <Label className="text-xs">품목그룹2 포함 문자열</Label>
                      <Input value={editingRule.prodCondition || ''} onChange={(e) => setEditingRule({ ...editingRule, prodCondition: e.target.value })} placeholder="예: 리코코" />
                    </div>
                  )}
                  <div className="flex items-end gap-2">
                    <label className="flex items-center gap-2 text-sm cursor-pointer">
                      <input type="checkbox" checked={!!editingRule.isRemainder} onChange={(e) => setEditingRule({ ...editingRule, isRemainder: e.target.checked })} />
                      나머지(기타) 계산
                    </label>
                  </div>
                </div>
                <div className="flex gap-2 pt-2">
                  <Button size="sm" onClick={handleSaveRule}>
                    <Save className="h-4 w-4 mr-1" />저장
                  </Button>
                  <Button size="sm" variant="outline" onClick={() => { setEditingRule(null); setEditingIndex(null); }}>취소</Button>
                </div>
              </div>
            )}

            <div className="flex gap-2">
              <Button variant="outline" size="sm" onClick={handleAddRule}>
                <Plus className="h-4 w-4 mr-1" />규칙 추가
              </Button>
              <Button variant="ghost" size="sm" className="text-muted-foreground" onClick={handleResetRules}>
                기본값으로 초기화
              </Button>
            </div>
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setIsRulesOpen(false)}>닫기</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
