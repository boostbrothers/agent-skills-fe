---
title: Platform Key Mapping Reference
impact: REFERENCE
impactDescription: iOS/Android 플랫폼별 키 매핑 전체 테이블과 엣지 케이스
tags: [device-data, userdefaults, sharedpreferences, key-mapping, platform, ios, android]
---

## Full Platform Key Mapping

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

## Edge Case Details

### 동적 키: userSSN
- Android에서 `userId` 파라미터로 실제 키 생성
- 예: userId='12345' → `USER_SSN_12345`
- **주의**: params 없으면 `USER_SSN_undefined` 생성
- iOS에서는 고정 키 `encryptQRSSNBackNumber` 사용 (userId 무시)

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
