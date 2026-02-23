---
title: PRD Document Structure
impact: CRITICAL
impactDescription: PRD 문서의 입력 파라미터, 출력 포맷, 섹션 구조를 정의
tags: [prd, structure, format, input, output]
---

## PRD Document Structure

**Impact: CRITICAL**

PRD 문서의 입력 파라미터와 출력 포맷 구조를 정의합니다.

### Input Parameters

PRD 생성에 필요한 4개의 입력 파라미터:

```
JIRA: {{JIRA_ISSUE_KEY}}
Confluence: {{CONFLUENCE_URL}}
Figma: {{FIGMA_DESIGN_URL}} {{FIGMA_FLOW_URL}}
Logging_JIRA: {{LOGGING_JIRA_ISSUE_KEY}}
```

자동 수집 워크플로우를 통해 추가로 확보되는 정보:
- `API_SPEC`: API 명세 URL
- `Related_Tasks`: 백엔드/프론트엔드 관련 작업 요약

### Output Format

- **Pure Markdown** only. No front-matter, no title (if handled by header), no markdown code blocks (` ``` `).
- Section delimiters: `---`.
- Respect spacing between Korean and English.

### Document Section Structure

PRD는 아래 섹션 순서를 반드시 따릅니다:

**Header (메타데이터)**
```markdown
# [PRD] {JIRA_ID}-{Feature_Name} v{Version} – {One-line Keyword}

> JIRA: [{JIRA_KEY}]({JIRA_URL})
> Confluence: [{기획 문서}]({CONFLUENCE_URL})
> Figma: [{디자인}]({FIGMA_DESIGN_URL}), [{플로우}]({FIGMA_FLOW_URL})
> 작성일: YYYY-MM-DD
> 작성자: {Author} ({Role}), {Author2} ({Role2})
> 리뷰어: {Reviewer} ({Role}), {Reviewer2} ({Role2})
```

**Section 1: 프로젝트 개요**
- 목표, 기대효과, 라이브 일정

**Section 2: 사용자 시나리오 (Job Story)**
- When · I want · So 구조의 단일 Job-Story

**Section 3: 요구사항 명세서 (SRS)**
- | ID | 우선순위 | 요구사항 | 상세 정의 | 비고 | 테이블

**Section 4: 디자인 & Flow**
- 화면별 하위 섹션 (화면 ID, Figma 링크)
- [UI 요소 및 인터랙션] - 번호 리스트
- [로직 및 정책 (Business Logic)] - 번호 리스트

**Section 5: API 명세 (개발팀용)**
- Endpoint, Request, Response, 에러 코드 테이블

**Section 6: 추적 & 로깅**
- 이벤트별 하위 섹션 (JIRA 링크, 이벤트명, 파라미터, 목적, 수집 툴)

**Section 7: 릴리스 & 이슈**
- 7.1 배포 일정
- 7.2 리스크 & 의존성
- 7.3 롤백 기준

**Section 8: 히스토리**
- | 일자 | 버전 | 변경점 | 작성자 | 테이블 (내림차순)
