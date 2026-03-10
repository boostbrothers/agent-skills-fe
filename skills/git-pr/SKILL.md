---
name: git-pr
description: Pull Request creation with team template and best practices. Use when creating PRs, pull requests, or when user says 'PR', 'pull request', 'PR 생성', 'PR 만들어'.
metadata:
  author: ddocdoc
  version: "1.0.0"
---

# git-pr

PR 생성 자동화 스킬. 브랜치, 커밋, diff를 분석해 한국어로 읽기 좋은 PR 초안을 생성합니다.

## Workflow

1. **컨텍스트 수집** — 스크립트 실행:
   ```bash
   bash /mnt/skills/user/git-pr/scripts/generate-pr.sh [base_branch]
   ```
2. **변경사항 분석** — 커밋 메시지와 diff를 읽고 작업 의도 파악
3. **PR 초안 작성** — 아래 템플릿 사용, 작업 내용을 한국어로 상세 작성
4. **사용자 확인** — 제목과 본문을 보여주고 승인 요청
5. **PR 생성** — 승인 후 실행:
   ```bash
   gh pr create --title "..." --body "$(cat <<'EOF'
   ...
   EOF
   )"
   ```
6. **PR URL 반환**

## PR Title Format

```
(chore|fix|feat): JIRA-ISSUE-NUMBER, 한국어 설명
```

예시: `feat: FE-1234, 로그인 화면 DPoP 인증 적용`

## PR Body Template (REQUIRED)

```markdown
## 작업 내용

<!-- 작업에 대한 배경이나 상세한 설명 추가 -->
<!-- 어떤 부분을 중점적으로 봐야 할지를 상세히 작성 -->

## 작업 관련 링크

<!-- JIRA 이슈 또는 레드마인 이슈번호 추가 -->
<!-- 액슈어, 제플린 및 피그마 링크 추가 -->

## 체크리스트

- [ ] 코드 리뷰어를 지정했는지 확인
- [ ] 담당자를 지정했는지 확인
- [ ] 라벨 및 프로젝트를 지정했는지 확인
- [ ] 작업 내용과 링크가 적절한지 확인
- [ ] 배포 테스트가 통과되는지 확인
- [ ] 환경변수가 추가되었는지 확인

## 기타 요청 사항

- 빠른 리뷰 부탁드립니다. 🙇
```

## Writing Guidelines

**가독성이 최우선입니다.** 리뷰어가 코드를 보기 전에 PR만 읽어도 무슨 작업인지 파악할 수 있어야 합니다.

- **작업 내용**: 커밋과 diff를 분석해 한국어로 작성. 변경 이유(why)와 방법(how)을 명확히
- **그룹화**: 관련 변경사항은 불릿 포인트로 묶어 작성
- **리뷰 포인트**: 리뷰어가 집중해야 할 부분을 명시
- **JIRA 링크**: 브랜치명에서 이슈 번호 감지 시 자동 추가 (`https://YOUR-JIRA-DOMAIN/browse/ISSUE-NUMBER` — 실제 도메인은 사용자가 설정)
- **base branch**: 기본값 `main`, 스크립트 첫 번째 인자로 변경 가능

## Notes

- PR 생성 전 현재 브랜치를 remote에 push했는지 확인 (`git push -u origin HEAD`)
- body 전달 시 반드시 HEREDOC 사용해 포맷 보존

## Output

스크립트 실행 시 JSON 출력 예시:
```json
{
  "branch": "feat/FE-4645",
  "base_branch": "main",
  "jira_issue": "FE-4645",
  "commits": "184d47e feat: FE-4645, DPoP 선택적 적용...\n1132ce0 feat: FE-4645, 신규 라이브러리 추가",
  "diff_stat": " src/api/auth.ts | 15 +++---\n 2 files changed",
  "diff_content": "diff --git a/src/api/auth.ts ...",
  "changed_files": "src/api/auth.ts\nsrc/utils/dpop.ts"
}
```

## Troubleshooting

- **jq not found**: `brew install jq`로 설치
- **gh CLI 미인증**: `gh auth login`으로 GitHub 인증 필요
- **No commits ahead of base**: base branch와 차이가 없는 경우 — rebase 상태 확인
- **Push 실패**: `git push -u origin HEAD`로 remote에 먼저 push
