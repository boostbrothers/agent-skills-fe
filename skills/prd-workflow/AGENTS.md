# PRD Workflow

**Version 1.0.0**
ddocdoc
February 2026

> **Note:**
> This document is mainly for agents and LLMs to follow when creating PRDs,
> generating acceptance tests, and managing the full product documentation workflow.
> Humans may also find it useful, but guidance here is optimized for automation
> and consistency by AI-assisted workflows.

---

## Abstract

PRD(제품 요구사항 정의서) 자동 생성 및 인수테스트 워크플로우 가이드. JIRA, Confluence, Figma 데이터를 수집하여 표준 PRD를 생성하고, UI/UX 중심 인수테스트를 자동 생성하여 Confluence에 업로드하는 전체 프로세스를 포함합니다.

---

## Table of Contents

1. [PRD Generation](#1-prd-generation) — **CRITICAL**
   - 1.1 [PRD Generation Rules](#11-prd-generation-rules)
   - 1.2 [PRD Document Structure](#12-prd-document-structure)
   - 1.3 [PRD Example Reference](#13-prd-example-reference)
2. [Acceptance Test Generation](#2-acceptance-test-generation) — **HIGH**
   - 2.1 [Acceptance Test Generation Rules](#21-acceptance-test-generation-rules)
   - 2.2 [Acceptance Criteria Checklist Format](#22-acceptance-criteria-checklist-format)
3. [Workflow Automation](#3-workflow-automation) — **MEDIUM**
   - 3.1 [Automated Data Gathering Workflow](#31-automated-data-gathering-workflow)
4. [Confluence Integration](#4-confluence-integration) — **MEDIUM**
   - 4.1 [Confluence Wiki Conversion and Upload Rules](#41-confluence-wiki-conversion-and-upload-rules)

---

## 1. PRD Generation

**Impact: CRITICAL**

PRD(제품 요구사항 정의서) 작성을 위한 핵심 규칙. 역할 지시, 13개 생성 규칙, 문서 구조, 포맷 가이드라인을 포함합니다. 모든 PRD는 이 규칙을 따라 일관된 품질과 형식으로 작성됩니다.

### 1.1 PRD Generation Rules

**Impact: CRITICAL**

PRD 작성 시 반드시 따라야 하는 역할 지시와 13개 생성 규칙입니다.

#### Role Instructions

- You are a 10-year experienced Product Manager and Technical Writer.
- Follow the company standard PRD template but strictly adhere to the **PRD_EXAMPLE** style (section structure, table format, Job-Story, logging specs).
- Write in a **precise and implementation-ready** level for developers, designers, and data teams.

#### Generation Rules

**IMPORTANT: All generated PRD content must be written in KOREAN.**

1. **Title**: Format as `[PRD] {JIRA_ID}-{Feature_Name} v{Version} – {One-line Keyword}`.
2. **Version**: Start at 1.0, increment by 0.1 for minor changes.
3. **User Scenario**: Must use exactly one **Job-Story** (When·I want·So structure).
4. **Requirements Spec (SRS) Table**: Must maintain the following columns (ID starts from R001):
   | ID | 우선순위 | 요구사항 | 상세 정의 | 비고 |
5. **Design & Flow** Section:
   - Screen ID format: `{{ScreenName}}-{{seq}}`.
   - UI Elements & Interactions: Use numbered lists (1. 2. 3.).
   - Business Logic: Use numbered lists (1. 2. 3.).
6. **API Spec** Table: Leave empty if no API links are provided.
7. **Tracking & Logging**: Use bullets for JIRA link, Event Name, Parameters, Purpose.
8. **History** Table: Columns: Date, Version, Changes, Author (descending order).
9. **Live Schedule**: Must use format "YYYY-MM-DD (배포)".
10. **Risks, Dependencies, Rollback**: Use bullets in Section 7.
11. **External Links**: Use markdown link format `[Text](URL)`.
12. **Markdown Compatibility**: Do not escape `>` chars (use `>`).
13. **Clean Output**: Output **only** the PRD body. No unnecessary comments, brackets, or conversational text.

#### Reference Material

- Benchmark **PRD_EXAMPLE** exactly.
  - Replace content 100% with the new feature details.
  - Maintain the same tone and word choice.

#### Acceptance Test Handoff

- After PRD generation, ask if the user wants to write acceptance tests.
- If "Yes": Ask for the Confluence `space_key`, then pass the generated md file path and `space_key` to the acceptance test generation rules.
- If "No": Terminate.

---

### 1.2 PRD Document Structure

**Impact: CRITICAL**

PRD 문서의 입력 파라미터와 출력 포맷 구조를 정의합니다.

#### Input Parameters

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

#### Output Format

- **Pure Markdown** only. No front-matter, no title (if handled by header), no markdown code blocks (` ``` `).
- Section delimiters: `---`.
- Respect spacing between Korean and English.

#### Document Section Structure

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

**Section 1: 프로젝트 개요** - 목표, 기대효과, 라이브 일정

**Section 2: 사용자 시나리오 (Job Story)** - When · I want · So 구조의 단일 Job-Story

**Section 3: 요구사항 명세서 (SRS)** - | ID | 우선순위 | 요구사항 | 상세 정의 | 비고 | 테이블

**Section 4: 디자인 & Flow** - 화면별 하위 섹션 (화면 ID, Figma 링크), [UI 요소 및 인터랙션], [로직 및 정책 (Business Logic)]

**Section 5: API 명세 (개발팀용)** - Endpoint, Request, Response, 에러 코드 테이블

**Section 6: 추적 & 로깅** - 이벤트별 하위 섹션 (JIRA 링크, 이벤트명, 파라미터, 목적, 수집 툴)

**Section 7: 릴리스 & 이슈** - 7.1 배포 일정, 7.2 리스크 & 의존성, 7.3 롤백 기준

**Section 8: 히스토리** - | 일자 | 버전 | 변경점 | 작성자 | 테이블 (내림차순)

---

### 1.3 PRD Example Reference

**Impact: CRITICAL**

아래는 PRD 작성 시 스타일과 톤의 기준이 되는 전체 예시 문서입니다. 새 PRD 작성 시 이 구조와 어투를 정확히 따르되, 내용은 100% 새 기능으로 교체합니다.

---

# [PRD] 콘텐츠 에디터 v1.0 - 홈 화면 콘텐츠 관리

> JIRA: [PRJ-1001](https://company.atlassian.net/browse/PRJ-1001)
> Confluence: [기획 문서](https://company.atlassian.net/wiki/spaces/PLAN/pages/12345678)
> Figma: [디자인](https://www.figma.com/design/example/ID?node-id=1-1&m=dev), [플로우](https://www.figma.com/design/example/ID?node-id=1-2&m=dev)
> 작성일: 2025-XX-XX
> 작성자: 김OO (기획), 이OO (디자인)
> 리뷰어: 박OO (개발리드), 최OO (데이터팀)

---

#### 1. 프로젝트 개요

- **목표**: 파트너 관리자가 **웹 기반 콘텐츠 에디터**를 통해 콘텐츠를 직접 작성하고, 앱 홈 화면에 노출하여 사용자 참여도를 높인다.
- **기대효과**:
  - 콘텐츠 제작 리드타임 50% 단축 (외부 의존성 제거)
  - 홈 화면 체류시간 20% 증가 목표
  - 콘텐츠 클릭률 15% 목표
- **라이브 일정**: 2025-XX-XX (배포)

---

#### 2. 사용자 시나리오 (Job Story)

> When **파트너 관리자가 새로운 콘텐츠를 제작해야 할 때**,
> I want to **웹 에디터에서 텍스트, 이미지, 유튜브를 쉽게 편집하고 앱에 즉시 반영하길 원하며**,
> So **별도의 개발 요청 없이 신속하게 사용자에게 유용한 정보를 전달할 수 있다**.

---

#### 3. 요구사항 명세서 (SRS)

| ID   | 우선순위 | 요구사항                 | 상세 정의                                                        | 비고                                    |
| ---- | -------- | ------------------------ | ---------------------------------------------------------------- | --------------------------------------- |
| R001 | P0       | 콘텐츠 에디터 권한 관리  | PA(Partner Admin)를 통해 권한이 부여된 사용자만 에디터 접근 가능 | 로그인 세션 유지 필요                   |
| R002 | P0       | 리치 텍스트 편집 기능    | 제목/본문 스타일 변경, 볼드, 이탤릭, 텍스트 색상 지원            | 웹뷰에서도 동일하게 렌더링              |
| R003 | P0       | 이미지 첨부 및 확대      | 로컬 이미지 업로드, 클릭 시 전체화면 확대                        | 최대 10MB, jpg/png 지원                 |
| R004 | P0       | 유튜브 임베드            | 유튜브 URL 입력 시 영상 플레이어 임베드                          | 앱 내 재생 지원                         |
| R005 | P0       | 썸네일 설정              | 콘텐츠 대표 이미지 1개 필수 업로드                               | 홈/리스트에서 노출                      |
| R006 | P1       | 콘텐츠 저장 및 목록 관리 | 작성 중인 콘텐츠 임시 저장, 목록 페이지에서 관리                 | 타이틀, 최초 작성일, 앱 링크, 관리 버튼 |
| R007 | P1       | 앱 링크 복사             | 콘텐츠 상세 페이지 딥링크 생성 및 클립보드 복사                  | 인수테스트 용도                         |
| R008 | P0       | PA 노출 설정 연동        | PA에서 노출 시작일 설정 및 노출 On/Off 토글                      | 홈 추천 영역과 배너 사이 위치           |
| R009 | P0       | 앱 홈 콘텐츠 영역 노출   | 스와이프 가능한 가로 스크롤 카드 형태로 최대 10개 노출           | 썸네일 + 타이틀                         |
| R010 | P0       | 콘텐츠 상세 페이지       | 타이틀, 작성자, 날짜, 본문, 좋아요 버튼, 공유 버튼 포함          | 뒤로가기 시 콘텐츠 목록으로 이동        |
| R011 | P1       | 좋아요 기능              | 하트 아이콘 클릭 시 토글 및 카운팅                               | 별색(#FF4081) 적용                      |
| R012 | P1       | 공유하기 기능            | 카카오톡 공유 시 썸네일 + 타이틀 + 본문 일부 + [자세히보기] 버튼 | 오픈그래프 메타태그 설정                |

---

#### 4. 디자인 & Flow

**4.1 콘텐츠 에디터 홈 (목록 페이지)**

- **화면 ID**: `EDITOR-HOME-001`
- **Figma 링크**: [홈\_콘텐츠 생성 후](https://www.figma.com/design/example/ID?node-id=1-3)

**[UI 요소 및 인터랙션]**

1. `Side Bar`: 좌측 사이드바에 "Editor" 로고 및 [콘텐츠 작성] 버튼 노출.
2. `Profile Area`: 우측 상단에 "관리자" 사용자명 + [로그아웃] 버튼.
3. `Table Header`: "타이틀", "최초 작성일", "앱 링크", "관리" 4개 컬럼.
4. `List Item`: 각 콘텐츠 행에 타이틀 텍스트, 작성일(YYYY.MM.DD), [링크 복사] 버튼, [관리] 버튼 배치.
5. `Hover State`: 행에 마우스 오버 시 배경색 #F5F5F5 적용.
6. `Empty State`: 콘텐츠 없을 시 빈 서랍 아이콘 + "아직 작성된 콘텐츠가 없습니다." 메시지 노출.

**[로직 및 정책 (Business Logic)]**

1. **권한 검증:** 에디터 페이지 진입 시 PA 세션 토큰 확인. 권한 없음 → 403 에러 페이지로 리다이렉트.
2. **목록 조회:** `GET /api/v1/contents?page=1&limit=20` 호출. 최신 작성일 기준 내림차순 정렬.
3. **링크 복사:** [링크 복사] 버튼 클릭 시 딥링크 생성, 클립보드 복사 후 토스트 노출.

---

**4.2 콘텐츠 작성/편집 페이지**

- **화면 ID**: `EDITOR-WRITE-001`
- **Figma 링크**: [에디터 옵션](https://www.figma.com/design/example/ID?node-id=1-4)

**[UI 요소 및 인터랙션]**

1. `Editor Toolbar`: 상단에 [제목], [본문], [볼드], [이탤릭], [색상], [이미지 추가], [유튜브 추가] 버튼 배치.
2. `Title Input`: 단일 라인 텍스트 입력, 최대 50자.
3. `Content Editor`: 멀티라인 리치 텍스트 에디터.
4. `Image Upload`: [이미지 추가] 클릭 → 파일 선택 모달 → 업로드 진행률 표시 → 에디터 내 이미지 삽입.
5. `YouTube Embed`: [유튜브 추가] 클릭 → URL 입력 모달 → 유효성 검사 후 플레이어 임베드.
6. `Thumbnail Upload`: 하단에 썸네일 이미지 업로드 영역 (필수, 최소 600x400px 권장).
7. `Save Button`: 우측 하단 [저장하기] 버튼, 클릭 시 로딩 스피너 노출.

**[로직 및 정책 (Business Logic)]**

1. **유효성 검사:** 타이틀/본문/썸네일 미입력 시 각각 에러 메시지 표시.
2. **이미지 업로드:** 최대 10MB, jpg/png 형식만 허용. 실패 시 토스트 노출.
3. **유튜브 URL 검증:** Regex 유효성 검사. 유효하지 않으면 에러 메시지.
4. **저장 처리:** Success → 토스트 + 목록 이동. Fail → 에러 메시지 표시.

---

**4.3 앱 홈 - 콘텐츠 영역**

- **화면 ID**: `APP-HOME-CONTENTS-001`

**[UI 요소 및 인터랙션]**

1. `Section Title`: "추천 콘텐츠" 텍스트 + [전체 보기] 버튼.
2. `Content Cards`: 가로 스크롤 가능한 카드 리스트 (썸네일 + 타이틀).
3. `Card Interaction`: 카드 클릭 시 콘텐츠 상세 페이지로 이동.
4. `[전체 보기] Button`: 클릭 시 콘텐츠 목록 페이지로 이동.

**[로직 및 정책 (Business Logic)]**

1. **콘텐츠 조회:** PA에서 노출 설정된 콘텐츠만 반환, 최신순 정렬.
2. **노출 위치:** 홈 화면에서 "추천 섹션"과 "배너(DA)" 사이에 삽입.
3. **스와이프 동작:** 좌우 스와이프하여 다음 콘텐츠 노출.

---

**4.4 앱 콘텐츠 상세 페이지**

- **화면 ID**: `APP-CONTENTS-DETAIL-001`

**[UI 요소 및 인터랙션]**

1. `Header`: 좌측 [< 뒤로가기] 버튼, 우측 [공유하기] 아이콘.
2. `Content Body`: 타이틀(H1), 작성자, 작성일, 본문(리치 텍스트), 이미지, 유튜브 영상.
3. `Like Button`: 하단 고정 영역에 하트 아이콘 + 좋아요 수 표시.
4. `Share Button`: [공유하기] 아이콘 클릭 시 네이티브 공유 바텀시트 노출.

**[로직 및 정책 (Business Logic)]**

1. **콘텐츠 조회:** 404 시 에러 페이지 노출.
2. **좋아요 토글:** 하트 색상 #FF4081(활성)/#CCCCCC(비활성), 카운트 증감.
3. **공유하기:** 카카오톡 공유 시 썸네일+타이틀+본문 100자+딥링크 전달. 오픈그래프 메타태그 설정.
4. **뒤로가기:** 콘텐츠 목록 페이지로 이동.

---

#### 5. API 명세 (개발팀용)

| 항목            | 값                                                                                    |
| --------------- | ------------------------------------------------------------------------------------- |
| **[목록 조회]** |                                                                                       |
| Endpoint        | `GET /api/v1/contents`                                                                |
| Request         | `?page=1&limit=20&status=all`                                                         |
| Response        | `{ "items": [...], "total": 45 }`                                                      |
| 에러 코드       | `401: unauthorized`, `500: internal_server_error`                                      |

| 항목              | 값                                                              |
| ----------------- | --------------------------------------------------------------- |
| **[콘텐츠 생성]** |                                                                 |
| Endpoint          | `POST /api/v1/contents`                                         |
| Request Body      | `{ "title": "...", "content": "...", "thumbnail": "..." }`     |
| 에러 코드         | `400`, `401`, `413`, `500`                                      |

| 항목                 | 값                                   |
| -------------------- | ------------------------------------ |
| **[앱 콘텐츠 조회]** |                                      |
| Endpoint             | `GET /api/v1/app/contents`           |
| Request              | `?status=published&limit=10`         |
| 에러 코드            | `404`, `500`                         |

| 항목                   | 값                                          |
| ---------------------- | ------------------------------------------- |
| **[콘텐츠 상세 조회]** |                                             |
| Endpoint               | `GET /api/v1/app/contents/{content_id}`     |
| 에러 코드              | `404`, `500`                                |

| 항목              | 값                                                 |
| ----------------- | -------------------------------------------------- |
| **[좋아요 토글]** |                                                    |
| Endpoint          | `POST /api/v1/app/contents/{content_id}/like`      |
| 에러 코드         | `401`, `404`, `500`                                |

---

#### 6. 추적 & 로깅

**6.1 콘텐츠 노출 이벤트**

- **이벤트명**: `impression_home_contents`
- **파라미터**: `index` (NUMBER), `contents_id` (STRING), `contents_title` (STRING)
- **목적**: 홈 화면 콘텐츠 영역 노출률 및 콘텐츠별 노출 빈도 측정

**6.2 콘텐츠 클릭 이벤트**

- **이벤트명**: `click_home_contents`
- **파라미터**: `index` (NUMBER), `contents_id` (STRING), `contents_title` (STRING)
- **목적**: 콘텐츠 클릭률(CTR) 및 사용자 관심도 분석

---

#### 7. 릴리스 & 이슈

- **배포 일정**: 백엔드/프론트엔드/인수테스트/QA → 서버+웹 배포 → 스토어 심사/배포 → 강제 업데이트
- **리스크**: 모바일 웹뷰 렌더링 일관성, CDN 지연
- **의존성**: 권한 관리 API, 앱 내 콘텐츠 영역, QA 완료
- **롤백 기준**: 크래시율 1% 초과, 로딩 실패율 5% 초과, 주요 기능 오동작

---

#### 8. 히스토리

| 일자       | 버전 | 변경점    | 작성자 |
| ---------- | ---- | --------- | ------ |
| 2025-XX-XX | v1.0 | 최초 작성 | 김OO   |

---

## 2. Acceptance Test Generation

**Impact: HIGH**

PRD 기반 UI/UX 중심 인수테스트 생성 규칙. QA 엔지니어 관점에서 사용자에게 보이는 기능만을 대상으로 간결한 체크리스트를 작성합니다. API, 캐싱, 성능, 보안, 로깅 테스트는 제외합니다.

### 2.1 Acceptance Test Generation Rules

**Impact: HIGH**

#### Role Instructions

- You are a 10-year experienced QA engineer and test design expert.
- **Automatically find and read PRD files** and analyze them.
- Write **concise and focused acceptance test checklists** based on PRD documents.
- **Focus exclusively on UI/UX verification** - exclude API, caching, performance, security, and logging tests.
- Keep the checklist simple (10-20 items) covering only essential user-visible functionality.
- Convert the written document to **Confluence wiki format** and upload it.

#### Input Parameters

```
space_key: {{CONFLUENCE_SPACE_KEY}}
```

#### PRD Auto-Read Procedure

1. **Search location** (우선순위 순):
   - PRD 생성 시 사용한 저장 경로가 있으면 해당 경로 우선 활용
   - 모노레포 (`apps/` 존재): `apps/*/docs/` 하위에서 검색
   - 싱글 프로젝트 (`apps/` 미존재): 프로젝트 루트의 `docs/` 하위에서 검색
2. **Filename pattern**: `.md` files starting with `[PRD]` or `PRD_`
3. **Exclude files**: `PRD_GENERATOR.md`, `PRD_EXAMPLE.md`, `ARGUMENT_TEST_GENERATOR.md`
4. **Selection criteria**: Most recently modified file
5. **Auto-extract**: JIRA Issue Key, Feature Name, Version, SRS (UI/UX only), Screen Information

#### Core Principles

- **Focus on UI/UX**: Only test user-visible features and interactions
- **Exclude development infrastructure**: Do NOT test API calls, caching policies, performance metrics, security protocols, logging events
- **Keep it simple**: Only include essential acceptance criteria that verify core functionality
- **Edge cases handled by QA**: Detailed edge cases will be written during actual QA process

#### Document Title Format

`[인수테스트] {JIRA}-{feature_name} v{version}`

#### Fixed Test Environment

Test environment must always be set to "개발환경".

#### Document Structure

1. **Overview** - Test purpose, related PRD links, test scope
2. **Prerequisites** - Test accounts, required data
3. **Acceptance Criteria Checklist** (REQUIRED - CORE SECTION)
4. **Test Result Summary** - Date, assignee, counts
5. **Notes** - Additional remarks

#### PRD Requirements Mapping Rules

**What to Include:**
- Screen/component visibility
- Button clicks and navigation
- Form input and validation messages
- Data display (text, images, lists)
- Screen transitions
- Basic error states visible to user

**What to Exclude:**
- API endpoint testing
- Response codes (200, 404, 500)
- Caching behavior
- Performance metrics
- Security testing
- Logging events
- Network error scenarios
- Device compatibility details

---

### 2.2 Acceptance Criteria Checklist Format

**Impact: HIGH**

#### Table Structure

```wiki
||No||구분||시나리오 (Acceptance Criteria)||기대 결과 (Expected Result)||Pass✅ / Fail❌||비고||
|1|{category}|{scenario_description}|{expected_result}| |{notes}|
```

#### Column Definitions

1. **No**: Sequential number (1, 2, 3, ...)
2. **구분 (Category)**: Feature category (e.g., "화면 노출", "버튼 클릭", "화면 이동", "데이터 표시")
3. **시나리오 (Acceptance Criteria)**: Clear, concise test scenario
4. **기대 결과 (Expected Result)**: Clear success criteria
5. **Pass✅ / Fail❌**: Leave empty for test execution
6. **비고 (Notes)**: Leave empty for test execution

#### Mapping Rules

- Extract scenarios from UI/UX requirements only
- Target 10-20 essential checklist items (not 40+)
- Group related scenarios under same category
- Keep scenarios atomic (one action → one result)
- Prioritize P0 scenarios first, then P1

#### Example

```wiki
||No||구분||시나리오 (Acceptance Criteria)||기대 결과 (Expected Result)||Pass✅ / Fail❌||비고||
|1|화면 노출|홈 화면 진입 시 병원 추천 영역 노출|병원 추천 카드가 shortcut 하단에 표시됨| | |
|2|데이터 표시|병원 추천 영역에 병원명, 진료과, 후킹 정보 표시|병원명, 진료과, 리뷰/진료항목 정보 정상 표시| | |
|3|버튼 클릭|병원 추천 카드 클릭|병원 상세 페이지로 이동| | |
|4|화면 이동|홈 메뉴 재선택 시 스크롤 최상단 이동|스크롤 위치가 최상단으로 이동| | |
|5|조건부 노출|조건 미만족 시 병원 추천 영역 숨김|영역이 노출되지 않고 에러 없음| | |
```

---

## 3. Workflow Automation

**Impact: MEDIUM**

JIRA, Confluence, Figma에서 데이터를 자동 수집하는 워크플로우. MCP 도구를 활용하여 PRD 작성에 필요한 정보를 자동으로 가져옵니다.

### 3.1 Automated Data Gathering Workflow

**Impact: MEDIUM**

사용자로부터 JIRA Issue Key만 입력받아, MCP 도구를 통해 PRD 작성에 필요한 모든 정보를 자동으로 수집하는 7단계 워크플로우입니다.

#### Step 1: Input Collection

JIRA Issue Key 또는 URL을 입력받습니다. GUI 환경에서는 osascript 기반 스크립트(`scripts/collect_prd_info.sh`, 스킬 내부 포함) 사용 가능하며, CLI 환경에서는 직접 질문합니다.

#### Step 2: Script Output Parsing

`COLLECTED_DATA_START`와 `COLLECTED_DATA_END` 사이의 출력에서 JIRA Issue Key를 파싱합니다.

#### Step 3: Fetch JIRA Details

- `getJiraIssue`: description + issuelinks 조회
- `getJiraIssueRemoteIssueLinks`: Confluence Page URL 확인

#### Step 4: Fetch Confluence Content

Confluence 페이지에서 추출:
- Figma Design URL (`figma.com/design` 패턴)
- Figma Flow URL (`figma.com/board` 패턴)
- Logging JIRA Key
- API Spec URL

#### Step 5: Fetch Figma Details

- Design URL → `get_design_context` / `get_metadata`
- Flow URL (FigJam) → `get_figjam`

#### Step 6: Fetch Related Tasks

- JQL: `parent = [JIRA_KEY]`로 자식 태스크 검색
- Backend, Frontend, QA 태스크 상태/담당자 요약

#### Step 7: Generate PRD

수집 데이터를 조합하여 PRD 생성 프롬프트를 구성합니다.

#### File Save

1. **경로 질문**: 사용자에게 PRD 저장 경로 선호를 먼저 질문
2. **유저 직접 지정**: 사용자가 특정 경로를 지정하면 해당 경로 사용
3. **자동 감지** (사용자가 경로를 지정하지 않은 경우):
   - `apps/` 디렉토리 존재 시 (모노레포): 하위 디렉토리 목록 제시 → 사용자 프로젝트 선택 → `apps/{선택한 프로젝트}/docs/`
   - `apps/` 디렉토리 미존재 시 (싱글 프로젝트): 프로젝트 루트의 `docs/`
4. 디렉토리 미존재 시 생성
5. 파일명: `PRD_JiraIssueKey_FeatureName_v1.0.md`

---

## 4. Confluence Integration

**Impact: MEDIUM**

마크다운에서 Confluence wiki 포맷으로 변환하고 업로드하는 규칙. 헤딩, 테이블, 링크, 코드 블록 등의 변환 문법과 업로드 절차를 포함합니다.

### 4.1 Confluence Wiki Conversion and Upload Rules

**Impact: MEDIUM**

#### Wiki Markup Syntax

| Markdown | Wiki |
|----------|------|
| `# 제목` | `h1. 제목` |
| `## 제목` | `h2. 제목` |
| `### 제목` | `h3. 제목` |
| `**bold**` | `*bold*` |
| `*italic*` | `_italic_` |
| `` `code` `` | `{{code}}` |
| `- item` | `* item` |
| `1. item` | `# item` |
| `[text](URL)` | `[text\|URL]` |
| `> quote` | `{quote}quote{quote}` |
| `---` | `----` |
| `\| Header \|` | `\|\|Header\|\|` |
| `\| Value \|` | `\|Value\|` |

#### Conversion Notes

1. Metadata quotes → `{quote}` blocks
2. Code/Data → `{{...}}`
3. Nested lists → `*`, `**`, `***`
4. Special characters don't need escaping
5. Keep only one empty line

#### Upload Procedure

1. Read PRD file → 2. Extract information → 3. Generate acceptance test → 4. Review and quality check → 5. Upload to Confluence → 6. Output results

#### Upload Command

```
confluence_create_page:
  space_key: "{{received_space_key}}"
  title: "[인수테스트] {{JIRA}}-{{feature_name}} v{{version}}"
  content: "{{wiki_format_content}}"
  content_format: "wiki"
```

#### Error Handling

- PRD 파일 미발견 → 에러 메시지, PRD 먼저 생성 요청
- 정보 추출 실패 → 에러 메시지, 파일 형식 확인 요청
- 업로드 실패 → MCP 에러 출력, space_key 확인 요청
