# React Native Device Data Module — Complete Reference

**Organization:** ddocdoc
**Version:** 1.0.0
**Date:** March 2026

## Abstract

iOS UserDefaults와 Android SharedPreferences에 대한 통합 인터페이스. 플랫폼별 키 매핑, 동적 키, JSON 변환, 타임스탬프 통일 기능을 제공합니다.

**Reference:** https://rn-libs.fe.ddocdoc.dev/docs/react-native-device-data-module

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Key Features](#key-features)
4. [Platform Key Mapping Reference](#platform-key-mapping-reference)
5. [Edge Case Details](#edge-case-details)
6. [Troubleshooting](#troubleshooting)

---

## Overview

@boostbrothers/react-native-device-data-module — iOS UserDefaults와 Android SharedPreferences에 대한 통합 인터페이스를 제공하는 네이티브 스토리지 모듈. 플랫폼별 스토리지 키 차이를 단일 통합 키 시스템으로 추상화합니다.

### When to Apply

- 네이티브 스토리지(UserDefaults/SharedPreferences)에 접근할 때
- 플랫폼 간 키 매핑이 필요할 때
- 동적 키(userId 기반) 사용 시
- 토큰, 디바이스 ID 등 저장된 값을 읽을 때

---

## Architecture

```
App Code
  ↓
UnifiedDeviceDataModule
  ↓
Platform Key Mapping
  ↓ Platform Detection
  ├── iOS → UserDefaults
  └── Android → SharedPreferences
        ↓ Value Transform (JSON 파싱)
        ↓ Timestamp 통일
```

> **중요**: 모든 통합 키(UnifiedKey)는 내부적으로 현재 플랫폼에 맞는 실제 스토리지 키로 변환됩니다. 플랫폼별 키 이름을 직접 사용할 필요가 없습니다.

---

## Key Features

| Feature | Description |
|---------|-------------|
| Unified Key System | iOS/Android 단일 키 이름 |
| Platform Key Mapping | 레거시 키 완전 호환 |
| Dynamic Key Support | 런타임 파라미터(userId 등) |
| Value Transform | Android JSON 자동 파싱 |
| Timestamp Unification | 플랫폼 간 시간 표준화 |

---

## Platform Key Mapping Reference

> **Impact:** REFERENCE — iOS/Android 플랫폼별 키 매핑 전체 테이블과 엣지 케이스

**Tags:** device-data, userdefaults, sharedpreferences, key-mapping, platform, ios, android

### Full Platform Key Mapping

| Unified Key | iOS Key | Android Key | 설명 |
|-------------|---------|-------------|------|
| requirePermissionSuccessScreen | firstStatus | firstAppOpen | 권한 요청 성공 화면 |
| deviceId | deviceToken | PREF_ANDROID_DEVICE_UUID | 기기 고유 ID |
| userSSN | encryptQRSSNBackNumber | USER_SSN_{userId} | 동적 키 (userId 필요) |
| familyReceiptPopUp | neverShowFamilyReceptionAlert | FAMILY_RECEIPT_NOTICE | 가족 접수 팝업 |
| kidsGrowthOverAgePopUp | neverGrowthFeedNotKidAlert | NEVER_SHOW_AGAIN_KIDS_GROWTH_OVER_AGE | 아이 성장 나이 초과 |
| appReviewPopUp | isShowReviewInducePopUp | DID_SHOW_APP_REVIEW_POP_UP | 앱 리뷰 유도 |
| accessToken | accessToken | DDOC_DOC_TOKEN | 액세스 토큰 |
| refreshToken | refreshToken | DDOCDOC_NEW_REFRESH_TOKEN | 리프레시 토큰 |
| expiresTimestamp | accessTokenExpiredDate | DDOCDOC_TOKEN_EXPIRES_DATE | 토큰 만료 시각 |
| fcmRegisterId | (없음) | FCM_REG_ID | Android 전용 FCM ID |
| familyEditAuthPopUp | isShowAuthenticationAlert | FAMILY_EDIT_PRIVACY_POPUP | 가족 수정 인증 |
| noLoginADPushAllowed | noLoginADPushAllowed | ALLOWED_AD_PUSH | 광고 푸시 허용 (JSON) |
| noLoginADPushAllowedTime | noLoginADPushAllowedTime | ALLOWED_AD_PUSH | 광고 푸시 변경 시각 (JSON) |

---

## Edge Case Details

### 동적 키: userSSN
- Android에서 `userId` 파라미터로 실제 키 생성
- 예: userId='12345' → `USER_SSN_12345`
- **주의**: params 없으면 `USER_SSN_undefined` 생성
- iOS에서는 고정 키 `encryptQRSSNBackNumber` 사용 (userId 무시)

```typescript
// userId='12345' → Android 키: 'USER_SSN_12345'
const ssn = await getDeviceData('userSSN', { userId: '12345' });
```

### Android 전용: fcmRegisterId
- iOS에서 호출 시 빈 문자열("") 반환
- Platform.OS 조건 처리 권장:

```typescript
import { Platform } from 'react-native';
const fcmId = Platform.OS === 'android'
  ? await getDeviceData('fcmRegisterId')
  : undefined;
```

### JSON 변환 키: noLoginADPushAllowed / noLoginADPushAllowedTime
Android에서 하나의 JSON 객체로 저장:
```json
{
  "enablePush": true,
  "changedDate": "2024-01-15T10:30:00.000Z"
}
```
모듈이 자동 분리:
- `noLoginADPushAllowed` → `enablePush` 필드 추출 → boolean
- `noLoginADPushAllowedTime` → `changedDate` → 밀리초 number

**주의**: iOS는 각각 별도 문자열로 저장되므로 타입이 다를 수 있음:
- iOS noLoginADPushAllowed: string ("true"/"false")
- Android noLoginADPushAllowed: boolean (true/false)

### 타임스탬프 정규화 규칙
밀리초 단위로 통일:
1. 이미 밀리초 (>1,000,000,000,000): 그대로 반환
2. 초 단위: × 1000
3. ISO 문자열: `new Date(value).getTime()`

예:
```
1704067200000  → 1704067200000 (밀리초, 그대로)
1704067200     → 1704067200000 (초→밀리초)
"2024-01-01T00:00:00.000Z" → 1704067200000 (ISO→밀리초)
```

---

## Troubleshooting

**키를 찾을 수 없음**: UnifiedKey 이름이 올바른지 확인. 플랫폼별 실제 키 이름은 위 Full Platform Key Mapping 테이블 참조.

**타입 불일치**: iOS/Android에서 같은 키가 다른 타입을 반환할 수 있음 (예: noLoginADPushAllowed — iOS: string, Android: boolean). 모듈의 Value Transform이 이를 처리하지만, 타입 단언 주의.

**동적 키 undefined**: params 객체에 필수 파라미터를 전달했는지 확인. userSSN은 { userId } 필수.

**Android JSON 파싱 실패**: SharedPreferences에 저장된 값이 유효한 JSON인지 확인.
