---
name: jira-workflow
description: Jira 티켓(Epic/Task/Subtask) 생성 시 제목 규칙, 디스크립션 자동 생성, Subtask 일괄 생성을 안내하는 스킬. "티켓 만들어줘", "Task 생성", "Subtask 생성", "티켓 구조 검토" 등의 요청에 트리거.
---

# jira-workflow

Jira 티켓을 올바르게 작성하고, 자동화 규칙이 정상 동작하도록 안내하는 스킬입니다.
중점과제는 테크스팩 수준의 상세 디스크립션을, 운영과제는 간결한 디스크립션을 자동 생성합니다.

## 언제 사용하나요?

- Jira 티켓(Epic/Task/Subtask)을 새로 만들 때
- 티켓 제목 형식이나 계층 구조가 맞는지 검토할 때
- 자동화가 동작하지 않는 원인을 파악할 때
- Subtask를 일괄 생성하거나 제목 목록을 만들어야 할 때

## 전제 조건

- **Atlassian MCP 연결**: Jira 티켓 조회/생성을 위해 필요
- **대상 프로젝트 코드베이스 접근**: 중점과제 테크스팩 생성 시, 대상 프로젝트의 디렉토리 구조와 기존 코드를 탐색하여 파일 경로 기반의 기술적 접근 방식을 작성합니다. 코드베이스에 접근할 수 없는 경우 컴포넌트/모듈명 수준으로 작성합니다.

### MCP 에러 대응

| 에러 상황 | 동작 |
|-----------|------|
| MCP 서버 미연결 | "Atlassian MCP 연결을 확인해주세요." 안내 후 중단 |
| 티켓 조회 실패 (404) | "티켓을 찾을 수 없습니다. 키를 확인해주세요." |
| 권한 없음 (403) | 디스크립션·Subtask 목록을 텍스트로 출력 (읽기 전용 모드) |
| 생성 실패 (서버 오류) | 생성된 내용을 텍스트로 출력하고 수동 생성 안내 |

> API 호출 실패 시 최대 1회 자동 재시도합니다. 재시도 후에도 실패하면 사용자에게 안내하고 수동 처리를 유도합니다.

## 파라미터

| 파라미터 | 설명 | 출처 |
|----------|------|------|
| `{{projectName}}` | 상위 Epic의 프로젝트명 | Epic 제목에서 자동 추출 |
| `{{serviceName}}` | 작업 대상 서비스명 | Epic 또는 PROD 티켓에서 자동 판단, 불명확 시 사용자 선택 |

> `{{projectName}}`은 상위 Epic 제목 앞 태그에서 추출합니다.
> Epic 제목이 `[상담톡] 채팅 기능 개발`이면 `{{projectName}}` = `상담톡`

> `{{serviceName}}`은 상위 Epic 티켓 또는 Epic 하위 PROD 티켓의 내용을 참고하여 작업 범위를 판단합니다.
> 작업 범위를 판단하기 어려운 경우, 임의로 입력하지 않고 `references/service-names.md`의 사용자 선택지 형식으로 선택지를 제공합니다.

## 참조 파일

| 파일 | 설명 |
|------|------|
| `references/ticket-structure.md` | 티켓 계층 구조, Task·Subtask 제목 규칙 |
| `references/automation-rules.md` | Jira 자동화 규칙 전체 목록 |
| `references/service-names.md` | 유효한 서비스명 목록 |
| `references/classify-issue-type.md` | 운영과제/중점과제 판별 기준 |
| `references/build-description.md` | Task 디스크립션 작성 기준 |
| `references/generate-subtasks.md` | Subtask 목록 생성 기준 |
| `templates/task-description-ops.md` | 운영과제 Task 디스크립션 템플릿 + 예시 |
| `templates/task-description-key.md` | 중점과제 Task 디스크립션 템플릿 + 예시 |
| `templates/subtask-list.md` | Subtask 목록 출력 템플릿 + 예시 |

## 입력 검증

실행 순서 진입 전, 사용자가 제공한 Epic 정보를 검증합니다.

| 상황 | 동작 |
|------|------|
| Epic 키가 유효하지 않음 (조회 실패) | "Epic `{키}`를 찾을 수 없습니다. 올바른 Epic 키를 입력해주세요." |
| Epic이 아닌 이슈 타입 (Task, Subtask 등) | "`{키}`는 `{이슈타입}`입니다. 상위 Epic 키를 입력해주세요." |
| 대상 프로젝트가 FE가 아닌 경우 | "입력한 Epic은 `{프로젝트}` 보드 소속입니다. FE 보드 Task를 생성하려면 FE 프로젝트의 Epic을 입력해주세요." |

## 실행 순서

1. `references/ticket-structure.md` 로 제목 형식 확인
2. **Task 중복 확인** (`references/build-description.md` "공통: 중복 확인" 참조)
   - 존재하면 → 업데이트 플로우 (diff 표시 → 사용자 확인)
   - 없으면 → 신규 생성 진행
3. `references/classify-issue-type.md` 로 과제 유형 판별
4. `references/build-description.md` 로 디스크립션 작성 기준 확인
5. 유형에 맞는 템플릿으로 디스크립션 작성
   - **중점과제**: 코드베이스 탐색 후 `templates/task-description-key.md` 형식으로 테크스팩 수준 자동 생성
   - **운영/내부과제**: `templates/task-description-ops.md` 형식으로 간결하게 작성
6. 디스크립션을 사용자에게 출력 → 확인("이 내용으로 Task를 생성할까요?") 후 Jira API로 Task 생성
7. `references/generate-subtasks.md` 로 Subtask 목록 생성 → `templates/subtask-list.md` 형식으로 출력
8. 사용자 확인("이대로 Subtask를 생성할까요?") 후 Jira API로 Subtask 생성

## 확인 단계에서 취소 시

각 확인 단계에서 사용자가 거부한 경우:

| 단계 | 취소 시 동작 |
|------|-------------|
| Task 업데이트 확인 (2단계) | 기존 Task 유지, 스킬 종료 |
| Task 생성 확인 (6단계) | 디스크립션 수정 요청을 받거나, 스킬 종료 |
| Subtask 생성 확인 (8단계) | Subtask 목록 수정 요청을 받거나, Subtask 생성만 건너뛰기 |

> 부분 실패(예: 5개 Subtask 중 3개 생성 후 API 에러) 시, `templates/subtask-list.md`의 "부분 실패 시 출력 형식"에 따라 결과를 안내하고 재시도 여부를 확인합니다.
