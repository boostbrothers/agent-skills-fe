# Jira 자동화 규칙

티켓 상태는 Git/배포 흐름에 따라 자동으로 전환됩니다.
**수동으로 상태를 변경하지 않아도 됩니다.**

## 규칙 목록

| 규칙 | 트리거 | 조건 | 전환 상태 |
|------|--------|------|-----------|
| Created | 브랜치 생성 | - | IN PROGRESS |
| PR | PR 생성 (Draft 제외) | - | IN REVIEW |
| Subtask 병합 | PR 병합 | Subtask인 경우 | DONE |
| Deploy(Development) | Development 배포 성공 | - | IN DEVELOPMENT |
| Deploy(Staging) | Staging 배포 성공 | - | IN STAGE |
| Deploy(Production) | Production 배포 성공 | - | IN SERVICE |
| 예정된 업무로 변경 | 기한/담당자 값 변경 | 상태=Backlog AND 기한·담당자 모두 있음 | SELECTED FOR DEVELOPMENT |
| Subtask 생성 시 | Subtask 만들어짐 | 이슈 유형=하위 작업 | 담당자·기한 상위에서 자동 복사 |

## 동작 조건

- 브랜치명에 티켓 번호 포함 필수 → `feature/FE-123`
- PR 제목에 티켓 번호 포함 필수 → `FE-123, 홈 화면 개선`
- 자동화는 단방향 (상위 상태로 되돌아가지 않음)
- Subtask 병합 규칙은 Subtask 티켓에만 적용됨
