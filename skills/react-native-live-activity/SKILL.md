---
name: react-native-live-activity
description: iOS Live Activity module for displaying hospital reception status on lock screen and Dynamic Island using ActivityKit. Use when working with live activity, hospital reception, 접수 상태, ActivityKit, Dynamic Island, or lock screen widget.
metadata:
  author: ddocdoc
  version: "1.0.0"
---

# React Native Live Activity

@boostbrothers/react-native-live-activity — Apple ActivityKit을 활용하여 병원 접수 상태를 잠금 화면과 Dynamic Island에 실시간 표시하는 네이티브 모듈. iOS 16.1 이상에서만 작동.

## When to Apply

Reference this skill when:
- iOS Live Activity를 구현할 때
- 병원 접수 상태를 잠금 화면에 표시할 때
- Dynamic Island에 실시간 정보를 표시할 때
- ActivityKit 관련 작업 시

## Platform Support

| Platform | Support | Note |
|----------|---------|------|
| iOS 16.1+ | ✅ | Full functionality |
| Android | ⚠️ | 에러 없이 동작하지만 실제 기능 없음 (Stub) |

> Android에서는 API 호출이 에러 없이 실행되지만 화면에 아무것도 표시되지 않습니다.

## State Machine

병원 접수 상태 흐름:

```
pending (접수 대기)
  ↓
waiting (대기 중)
  ↓
inProgress (진료 중)
  ↓
completed (완료)
```

| State | 의미 | Lock Screen 표시 |
|-------|------|------------------|
| pending | 접수 처리 전 | 접수 대기 중 |
| waiting | 접수 완료, 대기 중 | 대기 N번째 |
| inProgress | 진료 중 | 진료 중 |
| completed | 진료 완료 | 완료 |

## Architecture

```
React Native 앱
  ↓
LiveActivityManager
  ↓
ReactNativeLiveActivityModule (Native)
  ↓
ActivityKit
  ├── 잠금 화면 위젯
  ├── Dynamic Island (iPhone 14 Pro+)
  └── Push 알림 연동
```

## API Reference

### requestLiveActivities(items)

접수 목록을 기반으로 Live Activity를 시작하거나 업데이트합니다.

```typescript
import { LiveActivityManager } from '@boostbrothers/react-native-live-activity';

await LiveActivityManager.requestLiveActivities([
  {
    id: 'receipt-001',
    patientName: '홍길동',
    hospitalName: '서울병원',
    hospitalID: 'hospital-123',
    displayTreatWaiting: 3,
    state: 'waiting',
    link: 'ddocdoc://receipt/001',
  },
]);
```

**동작:**
- 빈 배열 전달 시 모든 활성 Activity 종료
- `hospitalID` 기준으로 그룹핑
- 기존 Activity가 있으면 업데이트, 없으면 새로 생성

### updateReceptionState(params)

특정 접수 상태를 업데이트합니다. 주로 푸시 알림 수신 후 호출.

```typescript
await LiveActivityManager.updateReceptionState({
  id: 'receipt-001',
  state: 'inProgress',
  displayTreatWaiting: 0,
});
```

### endAllActivities()

모든 활성 Live Activity를 종료합니다.

```typescript
await LiveActivityManager.endAllActivities();
```

### areActivitiesEnabled()

디바이스가 Live Activity를 지원하는지 확인합니다.

```typescript
const enabled = await LiveActivityManager.areActivitiesEnabled();
// true: iOS 16.1+ && 사용자 권한 허용
// false: 미지원 또는 권한 거부
```

## Type Definitions

### ReceptionStateLiveActivityItem

```typescript
interface ReceptionStateLiveActivityItem {
  id: string;                    // 접수 식별자
  patientName: string;           // 환자 이름
  hospitalName?: string;         // 병원 이름
  hospitalID?: string;           // 병원 ID (그룹핑 기준)
  displayTreatWaiting: number;   // 대기 인원 수
  state: 'pending' | 'waiting' | 'inProgress' | 'completed';
  link?: string;                 // 딥링크 URL
}
```

### UpdateReceptionStateParams

```typescript
interface UpdateReceptionStateParams {
  id: string;                    // 접수 식별자
  state?: string;                // 새 상태
  displayTreatWaiting?: number;  // 업데이트된 대기 인원
}
```

## Usage Example: Full Flow

```typescript
import { useEffect } from 'react';
import { LiveActivityManager } from '@boostbrothers/react-native-live-activity';

function useHospitalReception(receipts: Receipt[]) {
  useEffect(() => {
    async function updateActivities() {
      // 1. 지원 여부 확인
      const enabled = await LiveActivityManager.areActivitiesEnabled();
      if (!enabled) return;

      // 2. 접수 목록으로 Activity 시작/업데이트
      const items = receipts.map((r) => ({
        id: r.id,
        patientName: r.patientName,
        hospitalName: r.hospitalName,
        hospitalID: r.hospitalID,
        displayTreatWaiting: r.waitingCount,
        state: r.status,
        link: `ddocdoc://receipt/${r.id}`,
      }));

      await LiveActivityManager.requestLiveActivities(items);
    }

    updateActivities();

    // 3. 접수 없으면 모든 Activity 종료
    return () => {
      if (receipts.length === 0) {
        LiveActivityManager.endAllActivities();
      }
    };
  }, [receipts]);
}

// 푸시 알림으로 상태 업데이트
async function onPushReceived(data: { receiptId: string; state: string; waiting: number }) {
  await LiveActivityManager.updateReceptionState({
    id: data.receiptId,
    state: data.state,
    displayTreatWaiting: data.waiting,
  });
}
```

## Troubleshooting

**Live Activity가 표시되지 않음:**
- iOS 버전이 16.1 이상인지 확인
- 설정 > 앱 > Live Activity 권한이 허용되어 있는지 확인
- areActivitiesEnabled()로 지원 여부 체크

**업데이트가 반영되지 않음:**
- id가 기존 Activity의 id와 일치하는지 확인
- state 값이 유효한 값('pending', 'waiting', 'inProgress', 'completed')인지 확인

**Android에서 아무 일도 일어나지 않음:**
- 정상 동작. Android는 stub 구현으로 에러 없이 no-op 처리됨
- Platform.OS 체크로 iOS에서만 UI 관련 로직 실행 권장

**Dynamic Island에 표시되지 않음:**
- iPhone 14 Pro 이상에서만 지원
- 그 외 기기에서는 잠금 화면 위젯만 표시
