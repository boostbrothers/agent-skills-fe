---
name: git-commit
description: Git commit message generation following team conventions. Use when committing changes, creating commits, or when user says 'commit', 'git commit', '커밋'.
metadata:
  author: ddocdoc
  version: "1.0.0"
---

# git-commit

팀 컨벤션에 따라 커밋 메시지를 자동 생성하고 커밋을 실행합니다.

## Workflow

1. **컨텍스트 수집:** 스크립트를 실행해 브랜치, staged diff, 최근 커밋 정보를 수집합니다.
   ```bash
   bash scripts/generate-commit-msg.sh
   ```
2. **분석:** staged diff를 분석해 변경 유형(feat/fix/chore)과 한국어 설명을 결정합니다.
3. **초안 제시:** 커밋 메시지 초안을 사용자에게 보여주고 확인을 요청합니다.
4. **커밋 실행:** 사용자가 확인하면 `git commit`을 실행합니다.

## Commit Message Format

**Title:** `(chore|fix|feat): JIRA-ISSUE-NUMBER, 한국어 설명`

Examples:
- `feat: FE-4645, DPoP 선택적 적용을 위한 Axios 인터셉터 패턴 개선`
- `fix: FE-4586, 디자인 시스템 토큰 매핑 오류 수정`
- `chore: FE-4484, PRD 파일 탐색 경로 설정 변경`

JIRA 이슈가 없는 경우: `feat: 초기 프로젝트 설정`

## JIRA Issue Detection (Priority Order)

1. 현재 브랜치명에서 추출 (예: `feat/FE-4645` → `FE-4645`)
2. 브랜치에 JIRA 패턴이 없으면 최근 git log 10개에서 관련 이슈 검색
3. 관련 이슈가 없으면 JIRA 번호 생략

## Type Detection

| Type | When to use |
|------|-------------|
| `feat` | 새 기능, 새 기능 추가 |
| `fix` | 버그 수정, 오류 수정 |
| `chore` | 설정 변경, 문서, 리팩토링, 의존성 업데이트 |

## Body Format (non-trivial commits)

```
feat: FE-4645, DPoP 선택적 적용을 위한 Axios 인터셉터 패턴 개선

- Axios 인터셉터에 DPoP 헤더 선택적 추가 로직 구현
- 기존 인증 플로우와의 호환성 유지
- 단위 테스트 추가

Co-Authored-By: {git user.name} <{git user.email}>
```

## Important Rules

- 커밋 메시지는 반드시 다음으로 끝나야 합니다:
  ```
  Co-Authored-By: {git user.name} <{git user.email}>
  ```
  - `git config user.name`과 `git config user.email`에서 가져옵니다.
  - 예시: `Co-Authored-By: TAE HONG LEE <dea972@naver.com>`
- staged 변경사항이 없으면 사용자에게 알립니다.
- 설명은 가능하면 한국어로 작성합니다 (영어가 더 명확한 경우 영어 허용).

## Output

스크립트 실행 시 JSON 출력 예시:
```json
{
  "branch": "feat/FE-4645",
  "jira_issue": "FE-4645",
  "staged_stat": " src/api/auth.ts | 15 +++---\n 1 file changed",
  "staged_diff": "diff --git a/src/api/auth.ts ...",
  "recent_commits": "184d47e feat: FE-4645, DPoP 선택적 적용..."
}
```

## Troubleshooting

- **No staged changes**: `git add`로 변경사항을 먼저 staging
- **jq not found**: `brew install jq`로 설치
- **JIRA 이슈가 감지되지 않음**: 브랜치명에 `FE-1234` 형태가 없고 최근 커밋에도 없는 경우 생략됨
