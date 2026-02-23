# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. PRD Generation (prd)

**Impact:** CRITICAL
**Description:** PRD(제품 요구사항 정의서) 작성을 위한 핵심 규칙. 역할 지시, 13개 생성 규칙, 문서 구조, 포맷 가이드라인을 포함합니다. 모든 PRD는 이 규칙을 따라 일관된 품질과 형식으로 작성됩니다.

## 2. Acceptance Test Generation (test)

**Impact:** HIGH
**Description:** PRD 기반 UI/UX 중심 인수테스트 생성 규칙. QA 엔지니어 관점에서 사용자에게 보이는 기능만을 대상으로 간결한 체크리스트를 작성합니다. API, 캐싱, 성능, 보안, 로깅 테스트는 제외합니다.

## 3. Workflow Automation (workflow)

**Impact:** MEDIUM
**Description:** JIRA, Confluence, Figma에서 데이터를 자동 수집하는 워크플로우. MCP 도구를 활용하여 PRD 작성에 필요한 정보를 자동으로 가져옵니다.

## 4. Confluence Integration (confluence)

**Impact:** MEDIUM
**Description:** 마크다운에서 Confluence wiki 포맷으로 변환하고 업로드하는 규칙. 헤딩, 테이블, 링크, 코드 블록 등의 변환 문법과 업로드 절차를 포함합니다.
