---
title: Automated Data Gathering Workflow
impact: MEDIUM
impactDescription: JIRA, Confluence, Figma에서 PRD 작성에 필요한 데이터를 자동 수집하는 워크플로우
tags: [workflow, automation, jira, confluence, figma, mcp]
---

## Automated Data Gathering Workflow

**Impact: MEDIUM**

PRD 작성에 필요한 데이터를 JIRA, Confluence, Figma에서 자동으로 수집하는 7단계 워크플로우입니다.

### Overview

이 워크플로우는 사용자로부터 JIRA Issue Key만 입력받아, MCP 도구를 통해 PRD 작성에 필요한 모든 정보를 자동으로 수집합니다.

### Step 1: Input Collection

사용자로부터 JIRA Issue Key 또는 URL을 입력받습니다.

- GUI 환경에서는 macOS osascript 기반 입력 스크립트 사용 가능 (`scripts/collect_prd_info.sh`, 스킬 내부 포함)
- 스크립트 실패 시 또는 CLI 환경에서는 직접 사용자에게 질문
- 사용자 메시지에 이미 JIRA Key가 포함되어 있으면 해당 값 사용

**Input format**: `PJD-1702` 또는 full JIRA URL

### Step 2: Script Output Parsing

스크립트 사용 시, `COLLECTED_DATA_START`와 `COLLECTED_DATA_END` 사이의 출력에서 JIRA Issue Key를 파싱합니다.

### Step 3: Fetch JIRA Details

Atlassian MCP 도구를 사용하여 JIRA 이슈 정보를 가져옵니다:

- `getJiraIssue`: 이슈의 `description`과 `issuelinks` 조회
- `getJiraIssueRemoteIssueLinks`: **Confluence Page URL** 확인

### Step 4: Fetch Confluence Content

Confluence 페이지에서 다음 정보를 추출합니다:

- **Figma Design URL**: `figma.com/design` 패턴 검색
- **Figma Flow URL**: `figma.com/board` 또는 유사 flow 링크 검색
- **Logging JIRA Key**: "Log", "Tracking", "Logging" 키워드 또는 이슈 키 검색
- **API Spec URL**: "Swagger", "API", 또는 spec 링크 검색

### Step 5: Fetch Figma Details

MCP 도구를 사용하여 Figma 정보를 가져옵니다:

- **Figma Design URL** 발견 시: `get_design_context` 또는 `get_metadata`로 디자인 상세 추출
- **Figma Flow URL (FigJam)** 발견 시: `get_figjam`으로 플로우 상세 추출

### Step 6: Fetch Related Tasks

JQL 검색으로 관련 하위 작업을 조회합니다:

- `searchJiraIssuesUsingJql`: `parent = [JIRA_KEY]`로 자식 태스크 검색
- Backend, Frontend, QA 등 태스크의 상태와 담당자 요약

### Step 7: Generate PRD

수집된 데이터를 조합하여 PRD 생성 프롬프트를 구성합니다:

```
PRD_GENERATOR 규칙대로 PRD_EXAMPLE 스타일로 새 PRD를 작성해줘.
JIRA: [Original Jira Key]
Confluence: [Fetched Confluence URL]
Figma: [Fetched Design URL] [Fetched Flow URL]
Logging_JIRA: [Fetched Logging Key]
API_SPEC: [Fetched API URL]
Related_Tasks: [Summary of Backend/Frontend tasks found]
```

### File Save

생성된 PRD를 저장합니다:

1. `apps/` 폴더 내 디렉토리 목록을 조회
2. 사용자에게 프로젝트 선택 요청
3. `apps/[SELECTED_PROJECT]/docs/` 경로에 저장
4. 디렉토리 미존재 시 생성
5. 파일명: `PRD_JiraIssueKey_FeatureName_v1.0.md`
