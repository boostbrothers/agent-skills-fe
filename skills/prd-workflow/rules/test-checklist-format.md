---
title: Acceptance Criteria Checklist Format
impact: HIGH
impactDescription: 인수 기준 체크리스트의 테이블 구조와 작성 규칙을 정의
tags: [test, checklist, format, acceptance-criteria, table]
---

## Acceptance Criteria Checklist Format

**Impact: HIGH**

인수 기준 체크리스트 테이블의 구조, 컬럼 정의, 매핑 규칙, 예시입니다.

### Table Structure

```wiki
||No||구분||시나리오 (Acceptance Criteria)||기대 결과 (Expected Result)||Pass✅ / Fail❌||비고||
|1|{category}|{scenario_description}|{expected_result}| |{notes}|
|2|{category}|{scenario_description}|{expected_result}| |{notes}|
```

### Column Definitions

1. **No**: Sequential number (1, 2, 3, ...)
2. **구분 (Category)**: Feature category or component name
   - Examples: "화면 노출", "버튼 클릭", "화면 이동", "데이터 표시"
3. **시나리오 (Acceptance Criteria)**: Clear, concise test scenario
   - What action to perform
   - Include any prerequisites in the scenario
   - Example: "홈 화면 진입 시 병원 추천 영역 노출"
4. **기대 결과 (Expected Result)**: What should happen
   - Clear success criteria
   - Example: "병원 추천 카드가 shortcut 하단에 표시됨"
5. **Pass✅ / Fail❌**: Leave empty for test execution
   - Testers will fill with ✅ or ❌
6. **비고 (Notes)**: Leave empty for test execution
   - Testers will add observations, issues, or additional context

### What to Include

- Screen/component visibility and positioning
- Button clicks and user interactions
- Navigation between screens
- Form inputs and user-visible validation messages
- Data display (text, images, lists showing correctly)
- Basic error states visible to user (e.g., "권한 없음" message, empty states)

### What to Exclude

- API endpoint calls (GET /api/..., POST /api/...)
- HTTP response codes (200, 404, 500)
- Caching policies (CloudFront, Redis, 1시간 캐싱)
- Performance measurements (응답 시간 2초 이내)
- Security verification (HTTPS, encryption, authentication tokens)
- Logging events (impression_*, click_*, view_*)
- Event parameters (hospital_id, lat, lng)
- Network errors (timeout, connection failure)
- Device/browser compatibility testing (iOS 15+, Android 10+, Chrome)
- Infrastructure details (Search Server, database queries)

### Mapping Rules

- Extract scenarios from UI/UX requirements only
- Target 10-20 essential checklist items (not 40+)
- Group related scenarios under same category
- Keep scenarios atomic (one action → one result)
- Prioritize P0 scenarios first, then P1

### Example

```wiki
||No||구분||시나리오 (Acceptance Criteria)||기대 결과 (Expected Result)||Pass✅ / Fail❌||비고||
|1|화면 노출|홈 화면 진입 시 병원 추천 영역 노출|병원 추천 카드가 shortcut 하단에 표시됨| | |
|2|데이터 표시|병원 추천 영역에 병원명, 진료과, 후킹 정보 표시|병원명, 진료과, 리뷰/진료항목 정보 정상 표시| | |
|3|버튼 클릭|병원 추천 카드 클릭|병원 상세 페이지로 이동| | |
|4|화면 이동|홈 메뉴 재선택 시 스크롤 최상단 이동|스크롤 위치가 최상단으로 이동| | |
|5|조건부 노출|조건 미만족 시 병원 추천 영역 숨김|영역이 노출되지 않고 에러 없음| | |
```
