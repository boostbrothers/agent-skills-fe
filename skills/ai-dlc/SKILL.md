---
name: ai-dlc
description: AI-Driven Development Lifecycle (AI-DLC) — AI 네이티브 소프트웨어 개발 방법론. 새로운 애플리케이션 구축, 신규 프로젝트 시작, 시스템 설계, 요구사항 기반 아키텍처 설계, 전체 개발 라이프사이클 계획 시 반드시 이 스킬을 사용해야 합니다. 기존 시스템에 주요 기능 추가(브라운필드), 비즈니스 목표를 유저 스토리와 Unit으로 분해, DDD 기반 도메인 모델 설계(Entity, Aggregate, Value Object, Domain Event), 요구사항부터 배포까지의 체계적 개발 프로세스 요청 시에도 사용합니다. 트리거 문구: "새 프로젝트", "시스템 만들어", "처음부터 설계", "체계적으로 개발", "요구사항 분석부터", "도메인 모델 설계", "기존 앱에 기능 추가", "마이크로서비스 전환", AI-DLC, Inception, Mob Elaboration, Construction, Bolt, Unit, Intent, elevation 언급 시.
---

# AI-Driven Development Lifecycle (AI-DLC)

AI가 대화를 주도하고 사람이 의사결정을 검증하는, 구조화된 AI 네이티브 소프트웨어 개발 방법론입니다. AWS의 AI-DLC 방법론을 기반으로, 비즈니스 Intent부터 배포 및 운영 가능한 시스템까지 전체 라이프사이클을 안내합니다.

## 핵심 철학

전통적 방법론(Scrum, Kanban)은 사람이 주도하는 장기 프로세스를 위해 설계되었습니다. AI-DLC는 AI를 핵심 협업자로 삼아 개발 라이프사이클을 재설계합니다:

- **AI가 제안하고, 사람이 검증한다** — AI가 계획, 설계, 코드를 생성하고 사람이 승인, 개선, 방향 수정
- **빠른 반복 주기** — Bolt(반복 단위)는 주 단위가 아닌 시간/일 단위로 측정
- **도메인 주도 설계가 핵심** — DDD 원칙이 모든 Phase에 내장되어 있으며, 후순위가 아님
- **점진적 강화** — 각 Phase의 산출물이 다음 Phase의 풍부한 컨텍스트가 됨

## 산출물

| 산출물 | 설명 | 대응 개념 |
|--------|------|-----------|
| **Intent** | 상위 수준의 비즈니스 목표 또는 기능 명세 | Epic / Initiative |
| **Unit** | Intent에서 도출된, 독립적으로 구축 가능한 응집된 작업 단위 | Bounded Context / Epic |
| **Bolt** | Unit을 구현하기 위한 최소 반복 주기 | Sprint (단, 시간/일 단위) |
| **Domain Design** | 인프라와 독립적인 비즈니스 로직 모델 | Domain Model |
| **Logical Design** | NFR과 설계 패턴이 적용된 Domain Design의 확장 | Architecture Blueprint |
| **Deployment Unit** | 배포 준비가 완료된 코드, 설정, 인프라 패키지 | Release Artifact |

## 폴더 구조

모든 산출물은 `aidlc-docs/` 디렉토리에 저장됩니다:

```
aidlc-docs/
  plans/              # Level 1 계획, Bolt 계획
  requirements/       # Intent 문서, NFR, 리스크 기술
  story-artifacts/    # Unit별 인수 조건이 포함된 유저 스토리
  design-artifacts/   # 도메인 모델, 논리 설계, ADR
  prompts.md          # 이 세션에서 사용된 모든 AI-DLC 프롬프트 로그
```

신규 프로젝트를 시작할 때 이 구조를 먼저 생성합니다. 폴더가 이미 존재하면 그대로 사용합니다.

## 워크플로우 개요

```
Intent → Level 1 Plan → Inception → Construction → Operations
                            │              │              │
                       Mob Elaboration  Mob Construction  배포
                       유저 스토리      Domain Design     관측성
                       Unit 구성        Logical Design    유지보수
                       PRFAQ            코드 + 테스트
```

## Phase 1: Inception

Inception Phase는 비즈니스 Intent를 포착하고 **Mob Elaboration** 리추얼을 통해 구축 가능한 Unit으로 분해합니다.

### 실행 방법

1. **Intent 수신** — 사용자가 상위 수준의 목표를 제시 (예: "크로스셀링을 위한 추천 엔진 구축")
2. **명확화 질문** — 주요 사용자, 핵심 비즈니스 성과, 제약 조건, 규정 준수 요구사항 등을 파악
3. **유저 스토리 생성** — 인수 조건이 포함된 잘 정의된 유저 스토리 작성
4. **Unit 구성** — 높은 응집도의 스토리를 느슨하게 결합된 Unit으로 그룹화하여 독립 구축 가능하게 구성
5. **NFR 및 리스크 정의** — Unit별 비기능 요구사항과 리스크 기술서 작성
6. **PRFAQ 생성** (선택) — 비즈니스 Intent, 기능, 기대 효과를 요약
7. **Bolt 계획 수립** — Unit을 Bolt로 실행하는 방법 제안 (병렬 또는 순차)

### 생성되는 산출물

각 산출물을 마크다운 파일로 저장:

- `aidlc-docs/plans/inception_plan.md` — 체크박스가 포함된 단계별 계획
- `aidlc-docs/requirements/intent.md` — 명확화된 원본 Intent
- `aidlc-docs/requirements/nfr.md` — 비기능 요구사항
- `aidlc-docs/requirements/risks.md` — 리스크 기술서
- `aidlc-docs/story-artifacts/{unit-name}_stories.md` — Unit별 유저 스토리
- `aidlc-docs/plans/bolt_plan.md` — Bolt 실행 계획

### 검증 게이트

각 단계에서 산출물을 사용자에게 제시하고 명시적 승인을 받은 후 다음 단계로 진행합니다. 사용자는 다음 중 하나를 선택할 수 있습니다:
- 현재 상태 그대로 승인
- 수정 요청
- 누락된 고려사항 추가 (예: "데이터 수집 Unit에 GDPR 준수 요건 추가")

상세 Inception Phase 가이드는 `references/inception.md`를 참조하세요.

## Phase 2: Construction

Construction Phase는 Unit을 반복적인 Bolt를 통해 테스트 완료된 배포 가능 코드로 변환합니다.

### 실행 방법

Bolt에 할당된 각 Unit에 대해:

1. **Domain Design** — DDD 원칙을 활용하여 핵심 비즈니스 로직 모델링 (Entity, Value Object, Aggregate, Domain Event, Repository)
2. **개발자 검증** — 도메인 모델을 리뷰용으로 제시
3. **Logical Design** — NFR을 적용하고 아키텍처 패턴(CQRS, Event Sourcing, Circuit Breaker 등) 적용, ADR 작성
4. **개발자 검증** — 아키텍처 의사결정에 대한 승인 요청
5. **코드 생성** — 선택된 기술 스택에 매핑된 실행 가능한 코드 생성
6. **테스트 생성** — 기능, 보안, 성능 테스트 자동 생성
7. **테스트 실행** — 모든 테스트를 실행하고 결과를 분석하며 실패에 대한 수정안 제시
8. **개발자 검증** — 코드와 테스트 결과의 최종 리뷰

### 생성되는 산출물

- `aidlc-docs/design-artifacts/{unit-name}_domain_model.md` — 도메인 모델
- `aidlc-docs/design-artifacts/{unit-name}_logical_design.md` — ADR이 포함된 논리 설계
- `aidlc-docs/plans/{unit-name}_construction_plan.md` — 체크박스가 포함된 Construction 계획
- 사용자와 합의한 프로젝트 디렉토리 구조에 소스 코드 생성

### 브라운필드 적응

기존 시스템의 경우, Domain Design 전에 elevation 단계를 추가합니다:
1. AI가 기존 코드를 정적 모델(컴포넌트, 책임, 관계)과 동적 모델(주요 유스케이스의 상호작용 시퀀스)로 역공학
2. 개발자가 역공학된 모델을 검증
3. 표준 Construction 흐름을 진행

상세 Construction Phase 가이드는 `references/construction.md`를 참조하세요.

## Phase 3: Operations

Operations Phase는 배포, 관측성, AI 기반 유지보수를 다룹니다.

### 실행 방법

1. **Deployment Unit 패키징** — 컨테이너 이미지, 서버리스 함수, IaC (Terraform/CDK/CloudFormation)
2. **배포 계획 생성** — 사전 조건, 배포 단계, 롤백 절차 문서화
3. **관측성 구성** — 메트릭, 로그, 트레이스 수집 설정
4. **AI 모니터링** — 텔레메트리 분석으로 이상 감지, SLA 위반 예측, 완화 방안 제시
5. **인시던트 통합** — 자동화된 이슈 해결 권장사항을 위한 런북 연동

### 생성되는 산출물

- `aidlc-docs/plans/deployment_plan.md` — 사전 조건이 포함된 배포 계획
- `aidlc-docs/plans/observability_plan.md` — 모니터링 및 알림 전략

상세 Operations Phase 가이드는 `references/operations.md`를 참조하세요.

## 상호작용 프로토콜

모든 Phase에서 다음 상호작용 패턴을 따릅니다:

1. **먼저 계획** — Phase 단계를 실행하기 전에 계획 파일(체크박스가 포함된 마크다운)을 생성하고 승인 요청
2. **AI가 제안** — 산출물이나 권장사항을 생성
3. **사람이 검증** — 명시적 승인을 대기하며, 중요한 결정을 자율적으로 내리지 않음
4. **진행 표시** — 각 단계 완료 시 계획의 해당 체크박스를 체크
5. **프롬프트 기록** — 주요 프롬프트 교환 내용을 `aidlc-docs/prompts.md`에 추가

## 시작하기

사용자가 무언가를 구축하려는 Intent를 표현하면:

1. 초기화 스크립트를 실행하거나 `aidlc-docs/` 폴더 구조를 수동으로 생성
2. "이 프로젝트의 상위 수준 Intent는 무엇인가요?"라고 질문하여 Inception Phase 시작
3. Phase 워크플로우를 순차적으로 진행: Inception → Construction → Operations
4. 언제든 사용자가 "Construction으로 넘어가자" 또는 "도메인 모델에 집중하자"라고 말하면 해당 Phase나 단계로 이동 가능

```bash
# 프로젝트 구조 초기화
bash /mnt/skills/user/ai-dlc/scripts/init-project.sh
```

## 빠른 명령어

| 사용자 입력 | 동작 |
|-------------|------|
| "새 프로젝트: {설명}" | 주어진 Intent로 Inception 시작 |
| "이걸 Unit으로 분해해줘" | 현재 스토리에 대해 Unit 분해 실행 |
| "{unit}의 도메인 모델 설계해줘" | 특정 Unit에 대해 Construction 시작 |
| "Bolt 계획 세워줘" | Bolt 실행 계획 생성 |
| "{unit} 배포해줘" | Unit에 대해 Operations Phase 시작 |
| "기존 코드 분석해줘" | 브라운필드: 먼저 모델 역공학 수행 |
