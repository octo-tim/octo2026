/**
 * KPI 항목 관리 다이얼로그
 * 담당자, 카테고리, 업무, 지표를 편집할 수 있는 관리자용 모달
 */
import { useState, useEffect } from 'react';
import { trpc } from '@/lib/trpc';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { toast } from 'sonner';
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription,
} from '@/components/ui/dialog';
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from '@/components/ui/table';
import { Plus, Pencil, Trash2, Save, X, ChevronDown, ChevronRight, Loader2 } from 'lucide-react';
import { Badge } from '@/components/ui/badge';

interface KpiIndicator {
  id: number;
  kpiItemId: number;
  name: string;
  unit: string | null;
  sortOrder: number;
}

interface KpiItem {
  id: number;
  division: string;
  department: string;
  person: string;
  category: string;
  task: string;
  goal: string | null;
  isActive: boolean;
  sortOrder: number;
  indicators: KpiIndicator[];
}

interface KpiItemManageDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}

export function KpiItemManageDialog({ open, onOpenChange, onSaved }: KpiItemManageDialogProps) {
  const { data: kpiItems, refetch } = trpc.kpi.getItems.useQuery(undefined, { enabled: open });
  
  const createItemMutation = trpc.kpi.createItem.useMutation({
    onSuccess: () => { refetch(); onSaved(); toast.success('항목이 추가되었습니다.'); },
    onError: (e) => toast.error(e.message),
  });
  const updateItemMutation = trpc.kpi.updateItem.useMutation({
    onSuccess: () => { refetch(); onSaved(); toast.success('항목이 수정되었습니다.'); },
    onError: (e) => toast.error(e.message),
  });
  const deleteItemMutation = trpc.kpi.deleteItem.useMutation({
    onSuccess: () => { refetch(); onSaved(); toast.success('항목이 삭제되었습니다.'); },
    onError: (e) => toast.error(e.message),
  });
  const createIndicatorMutation = trpc.kpi.createIndicator.useMutation({
    onSuccess: () => { refetch(); onSaved(); toast.success('지표가 추가되었습니다.'); },
    onError: (e) => toast.error(e.message),
  });
  const updateIndicatorMutation = trpc.kpi.updateIndicator.useMutation({
    onSuccess: () => { refetch(); onSaved(); toast.success('지표가 수정되었습니다.'); },
    onError: (e) => toast.error(e.message),
  });
  const deleteIndicatorMutation = trpc.kpi.deleteIndicator.useMutation({
    onSuccess: () => { refetch(); onSaved(); toast.success('지표가 삭제되었습니다.'); },
    onError: (e) => toast.error(e.message),
  });

  const [expandedItemId, setExpandedItemId] = useState<number | null>(null);
  const [editingItemId, setEditingItemId] = useState<number | null>(null);
  const [editingIndicatorId, setEditingIndicatorId] = useState<number | null>(null);
  const [isAddingItem, setIsAddingItem] = useState(false);
  const [addingIndicatorForItemId, setAddingIndicatorForItemId] = useState<number | null>(null);
  const [itemForm, setItemForm] = useState({ division: '', department: '', person: '', category: '', task: '', goal: '' });
  const [indicatorForm, setIndicatorForm] = useState({ name: '', unit: '' });

  const startEditItem = (item: KpiItem) => {
    setEditingItemId(item.id);
    setItemForm({ division: item.division, department: item.department, person: item.person, category: item.category, task: item.task, goal: item.goal || '' });
  };

  const saveItem = () => {
    if (!itemForm.division || !itemForm.department || !itemForm.person || !itemForm.category || !itemForm.task) {
      toast.error('모든 필수 항목을 입력해주세요.');
      return;
    }
    if (editingItemId) {
      updateItemMutation.mutate({ id: editingItemId, ...itemForm });
    } else {
      createItemMutation.mutate(itemForm);
    }
    setEditingItemId(null);
    setIsAddingItem(false);
    setItemForm({ division: '', department: '', person: '', category: '', task: '', goal: '' });
  };

  const startEditIndicator = (ind: KpiIndicator) => {
    setEditingIndicatorId(ind.id);
    setIndicatorForm({ name: ind.name, unit: ind.unit || '' });
  };

  const saveIndicator = (kpiItemId: number) => {
    if (!indicatorForm.name) {
      toast.error('지표명을 입력해주세요.');
      return;
    }
    if (editingIndicatorId) {
      updateIndicatorMutation.mutate({ id: editingIndicatorId, ...indicatorForm });
    } else {
      createIndicatorMutation.mutate({ kpiItemId, ...indicatorForm });
    }
    setEditingIndicatorId(null);
    setAddingIndicatorForItemId(null);
    setIndicatorForm({ name: '', unit: '' });
  };

  const grouped = (kpiItems || []).reduce((acc: Record<string, KpiItem[]>, item: KpiItem) => {
    const key = `${item.division} > ${item.department}`;
    if (!acc[key]) acc[key] = [];
    acc[key].push(item);
    return acc;
  }, {});

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2 text-lg">
            KPI 항목 관리
          </DialogTitle>
          <DialogDescription>
            담당자, 카테고리, 업무, 지표를 추가/수정/삭제할 수 있습니다.
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4">
          {!isAddingItem ? (
            <Button size="sm" onClick={() => { setIsAddingItem(true); setEditingItemId(null); setItemForm({ division: '', department: '', person: '', category: '', task: '', goal: '' }); }} className="gap-1.5">
              <Plus className="w-4 h-4" />
              새 항목 추가
            </Button>
          ) : (
            <div className="p-4 border rounded-lg bg-muted/30 space-y-3">
              <div className="text-sm font-medium">새 KPI 항목 추가</div>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                <div>
                  <Label className="text-xs">사업부 *</Label>
                  <Input value={itemForm.division} onChange={(e) => setItemForm(prev => ({ ...prev, division: e.target.value }))} placeholder="매트사업부" className="h-8 text-sm" />
                </div>
                <div>
                  <Label className="text-xs">부서 *</Label>
                  <Input value={itemForm.department} onChange={(e) => setItemForm(prev => ({ ...prev, department: e.target.value }))} placeholder="마케팅팀" className="h-8 text-sm" />
                </div>
                <div>
                  <Label className="text-xs">담당자 *</Label>
                  <Input value={itemForm.person} onChange={(e) => setItemForm(prev => ({ ...prev, person: e.target.value }))} placeholder="홍길동" className="h-8 text-sm" />
                </div>
                <div>
                  <Label className="text-xs">카테고리 *</Label>
                  <Input value={itemForm.category} onChange={(e) => setItemForm(prev => ({ ...prev, category: e.target.value }))} placeholder="컨텐츠기획" className="h-8 text-sm" />
                </div>
                <div>
                  <Label className="text-xs">업무 *</Label>
                  <Input value={itemForm.task} onChange={(e) => setItemForm(prev => ({ ...prev, task: e.target.value }))} placeholder="이벤트 관리" className="h-8 text-sm" />
                </div>
                <div>
                  <Label className="text-xs">목표</Label>
                  <Input value={itemForm.goal} onChange={(e) => setItemForm(prev => ({ ...prev, goal: e.target.value }))} placeholder="월 10건 이상" className="h-8 text-sm" />
                </div>
              </div>
              <div className="flex gap-2">
                <Button size="sm" onClick={saveItem} disabled={createItemMutation.isPending} className="gap-1">
                  {createItemMutation.isPending && <Loader2 className="w-3 h-3 animate-spin" />}
                  <Save className="w-3 h-3" /> 저장
                </Button>
                <Button size="sm" variant="ghost" onClick={() => setIsAddingItem(false)}>취소</Button>
              </div>
            </div>
          )}

          {Object.entries(grouped).map(([groupKey, items]) => (
            <div key={groupKey} className="border rounded-lg overflow-hidden">
              <div className="bg-muted/40 px-4 py-2 text-sm font-semibold border-b">
                {groupKey} ({(items as KpiItem[]).length}개)
              </div>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-[30px]"></TableHead>
                    <TableHead className="w-[80px]">담당자</TableHead>
                    <TableHead className="w-[100px]">카테고리</TableHead>
                    <TableHead>업무</TableHead>
                    <TableHead className="w-[80px]">지표수</TableHead>
                    <TableHead className="w-[100px] text-right">관리</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {(items as KpiItem[]).map((item) => {
                    const isExpanded = expandedItemId === item.id;
                    const isEditing = editingItemId === item.id;
                    return (
                      <>
                        <TableRow key={item.id} className={isExpanded ? 'bg-muted/20' : ''}>
                          <TableCell>
                            <button onClick={() => setExpandedItemId(isExpanded ? null : item.id)} className="p-1 hover:bg-muted rounded">
                              {isExpanded ? <ChevronDown className="w-3.5 h-3.5" /> : <ChevronRight className="w-3.5 h-3.5" />}
                            </button>
                          </TableCell>
                          {isEditing ? (
                            <>
                              <TableCell><Input value={itemForm.person} onChange={(e) => setItemForm(prev => ({ ...prev, person: e.target.value }))} className="h-7 text-xs" /></TableCell>
                              <TableCell><Input value={itemForm.category} onChange={(e) => setItemForm(prev => ({ ...prev, category: e.target.value }))} className="h-7 text-xs" /></TableCell>
                              <TableCell><Input value={itemForm.task} onChange={(e) => setItemForm(prev => ({ ...prev, task: e.target.value }))} className="h-7 text-xs" /></TableCell>
                              <TableCell><Badge variant="secondary">{item.indicators.length}</Badge></TableCell>
                              <TableCell className="text-right">
                                <div className="flex justify-end gap-1">
                                  <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={saveItem} disabled={updateItemMutation.isPending}>
                                    <Save className="w-3.5 h-3.5 text-primary" />
                                  </Button>
                                  <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => setEditingItemId(null)}>
                                    <X className="w-3.5 h-3.5" />
                                  </Button>
                                </div>
                              </TableCell>
                            </>
                          ) : (
                            <>
                              <TableCell className="text-sm">{item.person}</TableCell>
                              <TableCell className="text-sm">{item.category}</TableCell>
                              <TableCell className="text-sm font-medium">{item.task}</TableCell>
                              <TableCell><Badge variant="secondary">{item.indicators.length}</Badge></TableCell>
                              <TableCell className="text-right">
                                <div className="flex justify-end gap-1">
                                  <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => startEditItem(item)}>
                                    <Pencil className="w-3.5 h-3.5" />
                                  </Button>
                                  <Button size="sm" variant="ghost" className="h-7 w-7 p-0 text-destructive" onClick={() => {
                                    if (confirm(`"${item.task}" 항목을 삭제하시겠습니까? 관련 지표와 실적 데이터도 함께 삭제됩니다.`)) {
                                      deleteItemMutation.mutate({ id: item.id });
                                    }
                                  }}>
                                    <Trash2 className="w-3.5 h-3.5" />
                                  </Button>
                                </div>
                              </TableCell>
                            </>
                          )}
                        </TableRow>
                        {isExpanded && (
                          <TableRow key={`${item.id}-indicators`}>
                            <TableCell colSpan={6} className="bg-muted/10 p-0">
                              <div className="px-8 py-3 space-y-2">
                                <div className="text-xs font-semibold text-muted-foreground mb-2">지표 목록</div>
                                {item.indicators.map((ind) => {
                                  const isEditingInd = editingIndicatorId === ind.id;
                                  return (
                                    <div key={ind.id} className="flex items-center gap-3 py-1.5 px-3 rounded bg-background border">
                                      {isEditingInd ? (
                                        <>
                                          <Input value={indicatorForm.name} onChange={(e) => setIndicatorForm(prev => ({ ...prev, name: e.target.value }))} placeholder="지표명" className="h-7 text-xs flex-1" />
                                          <Input value={indicatorForm.unit} onChange={(e) => setIndicatorForm(prev => ({ ...prev, unit: e.target.value }))} placeholder="단위" className="h-7 text-xs w-[80px]" />
                                          <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => saveIndicator(item.id)}>
                                            <Save className="w-3.5 h-3.5 text-primary" />
                                          </Button>
                                          <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => setEditingIndicatorId(null)}>
                                            <X className="w-3.5 h-3.5" />
                                          </Button>
                                        </>
                                      ) : (
                                        <>
                                          <span className="text-sm flex-1">{ind.name}</span>
                                          {ind.unit && <Badge variant="outline" className="text-xs">{ind.unit}</Badge>}
                                          <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => startEditIndicator(ind)}>
                                            <Pencil className="w-3 h-3" />
                                          </Button>
                                          <Button size="sm" variant="ghost" className="h-7 w-7 p-0 text-destructive" onClick={() => {
                                            if (confirm(`"${ind.name}" 지표를 삭제하시겠습니까?`)) {
                                              deleteIndicatorMutation.mutate({ id: ind.id });
                                            }
                                          }}>
                                            <Trash2 className="w-3 h-3" />
                                          </Button>
                                        </>
                                      )}
                                    </div>
                                  );
                                })}
                                {addingIndicatorForItemId === item.id ? (
                                  <div className="flex items-center gap-3 py-1.5 px-3 rounded bg-background border border-dashed border-primary/30">
                                    <Input value={indicatorForm.name} onChange={(e) => setIndicatorForm(prev => ({ ...prev, name: e.target.value }))} placeholder="새 지표명" className="h-7 text-xs flex-1" autoFocus />
                                    <Input value={indicatorForm.unit} onChange={(e) => setIndicatorForm(prev => ({ ...prev, unit: e.target.value }))} placeholder="단위 (건, 원 등)" className="h-7 text-xs w-[100px]" />
                                    <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => saveIndicator(item.id)}>
                                      <Save className="w-3.5 h-3.5 text-primary" />
                                    </Button>
                                    <Button size="sm" variant="ghost" className="h-7 w-7 p-0" onClick={() => { setAddingIndicatorForItemId(null); setIndicatorForm({ name: '', unit: '' }); }}>
                                      <X className="w-3.5 h-3.5" />
                                    </Button>
                                  </div>
                                ) : (
                                  <Button size="sm" variant="ghost" className="h-7 text-xs gap-1 text-muted-foreground" onClick={() => { setAddingIndicatorForItemId(item.id); setIndicatorForm({ name: '', unit: '' }); }}>
                                    <Plus className="w-3 h-3" /> 지표 추가
                                  </Button>
                                )}
                              </div>
                            </TableCell>
                          </TableRow>
                        )}
                      </>
                    );
                  })}
                </TableBody>
              </Table>
            </div>
          ))}

          {(!kpiItems || kpiItems.length === 0) && (
            <div className="text-center py-8 text-muted-foreground">
              등록된 KPI 항목이 없습니다.
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
