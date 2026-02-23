---
title: Confluence Wiki Conversion and Upload Rules
impact: MEDIUM
impactDescription: 마크다운에서 Confluence wiki 포맷으로의 변환 규칙과 업로드 절차
tags: [confluence, wiki, conversion, upload, format]
---

## Confluence Wiki Conversion and Upload Rules

**Impact: MEDIUM**

마크다운을 Confluence wiki 포맷으로 변환하는 문법 규칙과 업로드 절차입니다.

### Wiki Markup Syntax

**Headings:**

- `# 제목` → `h1. 제목`
- `## 제목` → `h2. 제목`
- `### 제목` → `h3. 제목`
- `#### 제목` → `h4. 제목`

**Text Styles:**

- `**bold**` → `*bold*`
- `*italic*` → `_italic_`
- `` `code` `` → `{{code}}`

**Lists:**

- `- item` → `* item`
- `1. item` → `# item`
- Nested lists are represented by number of `*` or `#` (`**`, `###`)

**Links:**

- `[text](URL)` → `[text|URL]`

**Blockquotes:**

- `> quote` → `{quote}quote{quote}`

**Code Blocks:**

- `` ```language `` → `{code:language}`
- `` ``` `` → `{code}`

**Tables:**

- `| Header1 | Header2 |` → `||Header1||Header2||`
- `| Value1 | Value2 |` → `|Value1|Value2|`

**Horizontal Rules:**

- `---` → `----`

**Checkboxes:**

- `- [ ] item` → `* [ ] item` (display as text)

### Conversion Notes

1. **Metadata quotes**: Convert PRD's `> JIRA:` format to `{quote}` blocks
2. **Code/Data**: Wrap emails, URLs, JSON etc. with `{{...}}`
3. **Nested lists**: Indentation is expressed as `*`, `**`, `***`
4. **Special characters**: `<`, `>`, `&` don't need escaping (automatically handled in wiki format)
5. **Line breaks**: Keep only one empty line

### Upload Procedure

**Execution Order:**

1. **Read PRD File** - Find latest PRD file in `docs/PRD/` folder, read entire contents

2. **Extract Information** - Extract JIRA issue key, feature name, version; parse requirements, screens, API, logging information

3. **Generate Acceptance Test** - Write acceptance test document following test generation rules; generate concise checklist focusing on UI/UX only (target 10-20 items); write in Confluence wiki format

4. **Review and Quality Check**
   - **MUST review the generated document for errors before upload**
   - Check for typos and spelling errors (especially in Korean text)
   - Verify incorrect characters or broken text
   - Verify table formatting is correct
   - Verify all links are properly formatted in wiki syntax `[text|URL]`
   - Check for wiki macro errors (e.g., accidental use of `{{variable}}` that looks like macros)
   - Fix any issues found before proceeding to upload

5. **Upload to Confluence** - Use Atlassian MCP tool:

```
confluence_create_page:
  space_key: "{{received_space_key}}"
  title: "[인수테스트] {{extracted_JIRA}}-{{extracted_feature_name}} v{{extracted_version}}"
  content: "{{generated_wiki_format_acceptance_test_full_content}}"
  content_format: "wiki"
```

6. **Output Results** - Output created Confluence page URL, summarize test case count

### Error Handling

1. **PRD 파일 미발견**: "PRD 파일을 찾을 수 없습니다. PRD를 먼저 생성해주세요."
2. **정보 추출 실패**: JIRA, feature name, version을 찾을 수 없으면 에러 메시지 출력, PRD 파일 형식 확인 요청
3. **Confluence 업로드 실패**: MCP 도구 에러 메시지 출력, space_key 확인 요청

### Output Format

업로드 완료 후 다음 정보를 출력합니다:

```
인수테스트 생성 완료!

PRD 파일: {PRD_filename}
JIRA: {JIRA_issue_key}
기능명: {feature_name}
버전: {version}

테스트 케이스 수:
- 인수 기준 체크리스트: {acceptance_criteria_count}개 항목 (UI/UX 중심)

Confluence 페이지: {created_page_URL}

다음 단계:
1. Confluence에서 테스트 케이스 확인
2. 개발 완료 후 테스트 진행
3. 결과를 Confluence 페이지에 직접 업데이트
```

### Example Output (Wiki Format)

```wiki
h1. [인수테스트] PRJ-1001-콘텐츠 에디터 v1.0

{quote}
*관련 PRD*: [PRJ-1001|https://company.atlassian.net/browse/PRJ-1001]
*Confluence*: [콘텐츠 에디터 기획|https://company.atlassian.net/wiki/spaces/PLAN/pages/12345678]
*Figma*: [디자인|https://www.figma.com/design/example/ID]
*작성일*: 2026-01-27
{quote}

----

h2. 1. 개요

h3. 1.1 테스트 목적

콘텐츠 에디터 기능의 핵심 UI/UX 요구사항이 정상적으로 구현되었는지 검증하고, 사용자가 콘텐츠를 작성하고 앱에 노출하는 전체 플로우가 정상 동작하는지 확인합니다.

h3. 1.2 테스트 범위

* 에디터 화면 노출 및 기본 UI 요소
* 텍스트 입력 및 스타일 적용
* 이미지/유튜브 첨부 기능
* 콘텐츠 저장 및 목록 관리
* 앱 홈 화면 콘텐츠 노출
* 앱 상세 페이지 및 인터랙션 (좋아요, 공유)

----

h2. 2. 전제 조건

h3. 2.1 테스트 계정

* *관리자 계정*: 개발환경 테스트 계정 사용
* *일반 사용자*: 앱 테스트 계정 사용

h3. 2.2 필수 데이터

* 개발 DB에 테스트 병원 데이터 존재
* PA에서 에디터 권한 설정 완료

----

h2. 3. 인수 기준 체크리스트 (Acceptance Criteria)

||No||구분||시나리오 (Acceptance Criteria)||기대 결과 (Expected Result)||Pass✅ / Fail❌||비고||
|1|에디터 화면|권한 있는 사용자로 에디터 접속|에디터 목록 페이지 정상 진입| | |
|2|기본 동작|리치 텍스트 에디터에 텍스트 입력|입력한 텍스트 정상 표시| | |
|3|스타일 적용|텍스트 선택 후 볼드 스타일 적용|선택한 텍스트가 볼드로 표시| | |
|4|이미지 첨부|이미지 업로드 버튼 클릭하여 이미지 첨부|이미지가 본문에 삽입됨| | |
|5|유튜브 첨부|유튜브 URL 입력하여 영상 첨부|유튜브 영상이 에디터에 표시됨| | |
|6|썸네일 설정|썸네일 이미지 업로드|썸네일이 설정되고 미리보기 표시| | |
|7|저장|콘텐츠 저장 버튼 클릭|콘텐츠가 목록에 추가됨| | |
|8|목록 조회|에디터 홈에서 콘텐츠 목록 확인|작성한 콘텐츠가 목록에 표시| | |
|9|앱 노출 설정|PA에서 콘텐츠 노출 설정 활성화|앱 홈 화면에 콘텐츠 영역 노출| | |
|10|앱 - 홈|앱 홈에서 콘텐츠 카드 클릭|콘텐츠 상세 페이지로 이동| | |
|11|앱 - 상세|콘텐츠 상세 페이지 진입|타이틀, 본문, 좋아요, 공유 버튼 표시| | |
|12|앱 - 상세|좋아요 버튼 클릭|좋아요 활성화 및 카운트 증가| | |

----

h2. 4. 테스트 결과 요약

* *테스트 일자*: (작성 예정)
* *담당자*: (작성 예정)
* *전체 케이스*: 12개
* *통과*: 0개
* *실패*: 0개
* *차단*: 0개

----

h2. 5. 참고 사항

* 본 인수테스트는 PRD PRJ-1001을 기반으로 자동 생성되었습니다.
* 테스트 진행 후 실제 결과를 체크리스트에 업데이트해주세요.
* 이슈 발견 시 JIRA에 등록해주세요.
```
