# 중점과제 Task 디스크립션 템플릿

PROD 보드 티켓 존재 여부에 따라 아래 두 가지 형식 중 하나를 사용합니다.
스킬이 PROD 티켓/Epic 정보를 분석하여 각 섹션을 자동 생성합니다.

## 섹션 작성 규칙

- 모든 섹션은 고정으로 포함합니다 (일관된 포맷 유지).
- 해당 사항이 없는 섹션은 `해당 없음`으로 표기합니다.
  - 예: API 연동이 없는 순수 UI 리팩토링 → `### API 연동` 아래에 `- 해당 없음`
  - 예: 상태 변경이 없는 작업 → `## 상태 관리` 아래에 `- 해당 없음`

---

## PROD 티켓이 있는 경우

### 템플릿

```
## 개요
{PROD 티켓 기반 배경, 목적, 핵심 요구사항 요약}

## 기술적 접근 방식

### 신규 생성
1. {파일 경로} — {설명}
2. {파일 경로} — {설명}

### 수정
1. {파일 경로} — {변경 내용}
2. {파일 경로} — {변경 내용}

### API 연동
- `{METHOD} {endpoint}` — {설명}

## 상태 관리
- {상태명}: {관리 방식 (react-query / zustand / local state 등)}
- {상태 간 의존 관계가 있다면 명시}

## 영향 범위
- {사이드이펙트가 예상되는 화면/기능}
- {공통 컴포넌트 수정 시 영향받는 다른 서비스}

## 작업 범위
- {구체적인 구현 항목 1}
- {구체적인 구현 항목 2}

## 참고
- PROD: {PROD 티켓 링크}
- Epic: {Epic 티켓 링크}
- Design: {디자인 링크 (있는 경우)}
```

### 예시

> Epic: [상담톡] 채팅 기능 개발
> PROD 티켓: [PROD-123] 상담톡 채팅 기능 기획서

```
## 개요
똑닥앱 내 병원-환자 간 실시간 채팅 기능을 구현합니다.
환자가 예약한 병원과 텍스트/이미지 메시지를 주고받을 수 있는 상담톡 화면을 추가합니다.

## 기술적 접근 방식

### 신규 생성
1. src/features/chat/components/ChatRoom.tsx — 채팅방 메시지 목록 화면
2. src/features/chat/components/ChatInput.tsx — 메시지 입력 컴포넌트
3. src/features/chat/hooks/useChatMessages.ts — 채팅 메시지 조회/전송 훅
4. src/features/chat/stores/chatStore.ts — WebSocket 실시간 메시지 상태 관리

### 수정
1. src/navigation/AppNavigator.tsx — 상담톡 라우트 추가
2. src/navigation/BottomTab.tsx — 상담톡 탭 추가
3. src/services/pushNotification.ts — 채팅 알림 타입 핸들러 추가

### API 연동
- `POST /api/chat/messages` — 메시지 전송
- `GET /api/chat/rooms` — 채팅방 목록 조회
- `WebSocket /ws/chat` — 실시간 메시지 수신

## 상태 관리
- 채팅방 목록: react-query로 서버 상태 캐싱
- 실시간 메시지: zustand store에서 WebSocket 메시지 수신/관리
- 메시지 입력 상태: ChatInput 내 local state

## 영향 범위
- BottomTab 레이아웃 변경 (탭 추가로 기존 탭 아이콘 간격 조정 필요)
- AppNavigator 라우트 추가
- 푸시 알림 핸들러에 채팅 알림 타입 추가 필요

## 작업 범위
- 상담톡 진입 화면(채팅방 목록) 구현
- 채팅방 화면(메시지 목록 + 입력) 구현
- 실시간 메시지 송수신 WebSocket 연동
- 채팅 관련 REST API 연동
- 푸시 알림 딥링크 처리

## 참고
- PROD: PROD-123
- Epic: FE-XXXX
- Design: figma.com/file/xxx
```

---

## PROD 티켓이 없는 경우

### 템플릿

```
## 개요
{Epic 기반 배경 및 목적 직접 작성}

## 기술적 접근 방식

### 신규 생성
1. {파일 경로} — {설명}

### 수정
1. {파일 경로} — {변경 내용}

### API 연동
- `{METHOD} {endpoint}` — {설명}

## 상태 관리
- {상태명}: {관리 방식}

## 영향 범위
- {사이드이펙트가 예상되는 화면/기능}

## 작업 범위
- {구체적인 구현 항목 1}
- {구체적인 구현 항목 2}

## 참고
- Epic: {Epic 티켓 링크}
- Design: {디자인 링크 (있는 경우)}
```

### 예시

```
## 개요
예약 확인 화면의 UI 및 사용성을 개선합니다.

## 기술적 접근 방식

### 신규 생성
1. src/features/reservation/components/ReservationDetail.tsx — 예약 상세 정보 표시 컴포넌트
2. src/features/reservation/hooks/useCancelReservation.ts — 예약 취소 처리 훅

### 수정
1. src/features/reservation/components/ReservationList.tsx — 예약 목록 레이아웃 개선
2. src/features/reservation/components/CancelModal.tsx — 취소 플로우 UX 개선

### API 연동
- `DELETE /api/reservations/{id}` — 예약 취소
- `GET /api/reservations/{id}` — 예약 상세 조회

## 상태 관리
- 예약 상세 데이터: react-query로 서버 상태 캐싱
- 취소 모달 상태: CancelModal 내 local state

## 영향 범위
- 예약 목록 화면 레이아웃 변경
- 취소 완료 후 예약 목록 캐시 무효화 필요

## 작업 범위
- 예약 상세 화면 레이아웃 개선
- 예약 취소 플로우 UX 개선

## 참고
- Epic: FE-XXXX
```
