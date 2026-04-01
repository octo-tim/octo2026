/**
 * 채널별실적 엑셀 업로드 컴포넌트
 * 
 * 엑셀 파일을 업로드하면 미리보기 → 주차 선택 → DB 저장
 * 봄봄시공/리코코시공 브랜드 선택 가능
 */
import { useState, useRef } from 'react';
import { Button } from '@/components/ui/button';
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
import { Upload, FileSpreadsheet, Loader2, CheckCircle2, AlertCircle, ArrowRight } from 'lucide-react';
import { Badge } from '@/components/ui/badge';

interface ParsedChannel {
  excelName: string;
  channel: string;
  subChannel: string;
  inflow: number;
  reservation: number;
  conversionRate: number;
  mapped: boolean;
}

interface PreviewData {
  success: boolean;
  year: number;
  month: number;
  startDate: string;
  endDate: string;
  week: number;
  channels: ParsedChannel[];
  totalInflow: number;
  totalReservation: number;
  channelCount: number;
  unmappedCount: number;
}

interface ContractExcelUploadProps {
  brand: string;
  brandLabel: string;
  year: number;
  month: number;
  onImportComplete: () => void;
}

export default function ContractExcelUpload({ brand, brandLabel, year, month, onImportComplete }: ContractExcelUploadProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  const [preview, setPreview] = useState<PreviewData | null>(null);
  const [selectedWeek, setSelectedWeek] = useState<string>('');
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // 엑셀 파일 확인
    if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
      toast.error('엑셀 파일(.xlsx, .xls)만 업로드 가능합니다.');
      return;
    }

    setSelectedFile(file);
    setIsLoading(true);
    setPreview(null);

    try {
      const formData = new FormData();
      formData.append('file', file);

      const res = await fetch('/api/contract/upload/preview', {
        method: 'POST',
        body: formData,
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || '미리보기 실패');
      }

      setPreview(data);
      setSelectedWeek(String(data.week));
    } catch (err) {
      toast.error('엑셀 파싱 실패: ' + (err as Error).message);
    } finally {
      setIsLoading(false);
    }
  };

  const handleImport = async () => {
    if (!selectedFile || !preview || !selectedWeek) return;

    setIsImporting(true);
    try {
      const formData = new FormData();
      formData.append('file', selectedFile);
      formData.append('week', selectedWeek);
      formData.append('brand', brand);

      const res = await fetch('/api/contract/upload/import', {
        method: 'POST',
        body: formData,
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || '저장 실패');
      }

      toast.success(`${brandLabel} ${data.week}주차 계약현황이 입력되었습니다. (${data.entriesCount}개 채널)`);
      setIsOpen(false);
      setPreview(null);
      setSelectedFile(null);
      setSelectedWeek('');
      if (fileInputRef.current) fileInputRef.current.value = '';
      onImportComplete();
    } catch (err) {
      toast.error('저장 실패: ' + (err as Error).message);
    } finally {
      setIsImporting(false);
    }
  };

  const handleClose = () => {
    setIsOpen(false);
    setPreview(null);
    setSelectedFile(null);
    setSelectedWeek('');
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  const formatNumber = (n: number) => new Intl.NumberFormat('ko-KR').format(n);

  return (
    <>
      <Button
        size="sm"
        variant="outline"
        onClick={() => setIsOpen(true)}
        className="gap-1.5"
      >
        <Upload className="h-4 w-4" />
        엑셀 업로드
      </Button>

      <Dialog open={isOpen} onOpenChange={handleClose}>
        <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <FileSpreadsheet className="h-5 w-5" />
              채널별실적 엑셀 업로드 - {brandLabel}
            </DialogTitle>
            <DialogDescription>
              채널별실적 엑셀을 업로드하면 해당 주차의 계약현황에 예약 건수가 자동 입력됩니다.
            </DialogDescription>
          </DialogHeader>

          {/* 주차 선택 + 파일 선택 영역 */}
          <div className="space-y-4">
            {/* 주차 선택 (파일 선택 전에 먼저 표시) */}
            <div className="flex items-center gap-3">
              <span className="text-sm font-medium whitespace-nowrap">입력할 주차:</span>
              <Select value={selectedWeek} onValueChange={setSelectedWeek}>
                <SelectTrigger className="w-[140px]">
                  <SelectValue placeholder="주차 선택" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="1">1주차</SelectItem>
                  <SelectItem value="2">2주차</SelectItem>
                  <SelectItem value="3">3주차</SelectItem>
                  <SelectItem value="4">4주차</SelectItem>
                  <SelectItem value="5">5주차</SelectItem>
                </SelectContent>
              </Select>
              <span className="text-xs text-muted-foreground">
                ※ 해당 주차의 예약 건수가 덮어씌워집니다
              </span>
            </div>

            {/* 파일 선택 */}
            <div className="flex items-center gap-3">
              <input
                ref={fileInputRef}
                type="file"
                accept=".xlsx,.xls"
                onChange={handleFileSelect}
                className="hidden"
              />
              <Button
                variant="outline"
                onClick={() => fileInputRef.current?.click()}
                disabled={isLoading}
                className="gap-2"
              >
                {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <FileSpreadsheet className="h-4 w-4" />}
                {selectedFile ? '다른 파일 선택' : '엑셀 파일 선택'}
              </Button>
              {selectedFile && (
                <span className="text-sm text-muted-foreground">{selectedFile.name}</span>
              )}
            </div>

            {/* 미리보기 */}
            {preview && (
              <div className="space-y-4">
                {/* 요약 정보 */}
                <div className="grid grid-cols-2 gap-3 p-4 bg-muted/50 rounded-lg">
                  <div>
                    <span className="text-xs text-muted-foreground">산출기간</span>
                    <p className="text-sm font-medium">{preview.startDate} ~ {preview.endDate}</p>
                  </div>
                  <div>
                    <span className="text-xs text-muted-foreground">자동 감지 주차</span>
                    <p className="text-sm font-medium">{preview.year}년 {preview.month}월 {preview.week}주차</p>
                  </div>
                  <div>
                    <span className="text-xs text-muted-foreground">채널 수</span>
                    <p className="text-sm font-medium">{preview.channelCount}개 채널</p>
                  </div>
                  <div>
                    <span className="text-xs text-muted-foreground">합계</span>
                    <p className="text-sm font-medium">유입 {formatNumber(preview.totalInflow)} / 예약 {formatNumber(preview.totalReservation)}</p>
                  </div>
                </div>

                {/* 매핑 안 된 채널 경고 */}
                {preview.unmappedCount > 0 && (
                  <div className="flex items-start gap-2 p-3 bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-800 rounded-lg">
                    <AlertCircle className="h-4 w-4 text-amber-500 mt-0.5 flex-shrink-0" />
                    <div className="text-sm text-amber-700 dark:text-amber-300">
                      <span className="font-medium">{preview.unmappedCount}개 채널</span>이 기존 매핑에 없어 외부채널로 자동 분류됩니다.
                    </div>
                  </div>
                )}

                {/* 채널별 데이터 테이블 */}
                <div className="border rounded-lg overflow-hidden">
                  <Table>
                    <TableHeader>
                      <TableRow>
                        <TableHead className="w-[60px]">상태</TableHead>
                        <TableHead className="w-[120px]">엑셀 채널명</TableHead>
                        <TableHead>
                          <ArrowRight className="h-3 w-3 inline" /> 매핑 결과
                        </TableHead>
                        <TableHead className="text-right w-[70px]">유입</TableHead>
                        <TableHead className="text-right w-[70px]">예약</TableHead>
                        <TableHead className="text-right w-[50px]">%</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      {preview.channels.map((ch, idx) => (
                        <TableRow key={idx} className={!ch.mapped ? 'bg-amber-50/50 dark:bg-amber-950/20' : ''}>
                          <TableCell>
                            {ch.mapped ? (
                              <CheckCircle2 className="h-4 w-4 text-green-500" />
                            ) : (
                              <AlertCircle className="h-4 w-4 text-amber-500" />
                            )}
                          </TableCell>
                          <TableCell className="font-medium text-sm">{ch.excelName}</TableCell>
                          <TableCell>
                            <div className="flex items-center gap-1.5">
                              <Badge variant={ch.channel === '내부채널' ? 'default' : 'secondary'} className="text-xs">
                                {ch.channel}
                              </Badge>
                              <span className="text-sm">{ch.subChannel}</span>
                            </div>
                          </TableCell>
                          <TableCell className="text-right font-mono text-sm">{formatNumber(ch.inflow)}</TableCell>
                          <TableCell className="text-right font-mono text-sm font-medium">{formatNumber(ch.reservation)}</TableCell>
                          <TableCell className="text-right font-mono text-sm text-muted-foreground">{ch.conversionRate}%</TableCell>
                        </TableRow>
                      ))}
                      {/* 합계 행 */}
                      <TableRow className="bg-muted/50 font-medium">
                        <TableCell></TableCell>
                        <TableCell>합계</TableCell>
                        <TableCell></TableCell>
                        <TableCell className="text-right font-mono">{formatNumber(preview.totalInflow)}</TableCell>
                        <TableCell className="text-right font-mono">{formatNumber(preview.totalReservation)}</TableCell>
                        <TableCell className="text-right font-mono text-muted-foreground">
                          {preview.totalInflow > 0 ? Math.round(preview.totalReservation / preview.totalInflow * 100) : 0}%
                        </TableCell>
                      </TableRow>
                    </TableBody>
                  </Table>
                </div>
              </div>
            )}
          </div>

          <DialogFooter className="gap-2 sm:gap-0">
            <Button variant="ghost" onClick={handleClose}>취소</Button>
            <Button
              onClick={handleImport}
              disabled={!preview || !selectedWeek || isImporting}
              className="gap-2"
            >
              {isImporting ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Upload className="h-4 w-4" />
              )}
              {selectedWeek ? `${selectedWeek}주차에 입력` : '주차를 선택하세요'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
