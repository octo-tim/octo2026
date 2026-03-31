# Database Dump

업무관리 시스템(task-manager) 프로덕션 데이터베이스의 전체 백업 파일입니다.

## 파일 설명

| 파일 | 설명 | 크기 |
|------|------|------|
| `schema.sql` | 테이블 구조(CREATE TABLE)만 포함 | 36 KB |
| `data.sql` | 데이터(INSERT)만 포함 | 116 KB |
| `full-dump.sql` | 스키마 + 데이터 통합 파일 | 152 KB |

## 포함된 테이블 (36개)

- `users` - 사용자
- `teams` - 팀/부서
- `divisions` - 사업부
- `positions` - 직책
- `ranks` - 직급
- `tasks` - 업무
- `task_progress_logs` - 업무 진행 로그
- `task_attachments` - 업무 첨부파일
- `archived_tasks` - 보관된 업무
- `archived_task_progress_logs` - 보관된 업무 진행 로그
- `sales_records` - 매출 기록
- `sales_categories` - 매출 카테고리
- `sales_items` - 매출 항목
- `sales_events` - 매출 이벤트
- `contract_records` - 계약 기록
- `contract_channels` - 계약 채널
- `contract_sub_channels` - 계약 하위 채널
- `businessPlans` - 사업계획
- `businessPlanActuals` - 사업계획 실적
- `businessPlanHistory` - 사업계획 이력
- `contractBusinessPlans` - 계약 사업계획
- `contractBusinessPlanHistory` - 계약 사업계획 이력
- `kpi_items` - KPI 항목
- `kpi_indicators` - KPI 지표
- `kpi_records` - KPI 기록
- `kpi_targets` - KPI 목표
- `kpi_assignees` - KPI 담당자
- `kpi_item_details` - KPI 항목 상세
- `goals` - 비전/목표
- `meeting_minutes` - 회의록
- `monthly_messages` - 월간 메시지
- `quarterly_reviews` - 분기 리뷰
- `reports` - 보고서
- `financial_records` - 재무 기록
- `financial_balances` - 재무 잔액

## 복원 방법

```bash
# 스키마만 복원
mysql -u [user] -p [database] < schema.sql

# 데이터만 복원
mysql -u [user] -p [database] < data.sql

# 전체 복원 (스키마 + 데이터)
mysql -u [user] -p [database] < full-dump.sql
```

## 생성 일시

2026-03-31 (UTC)
