---
title: Troubleshooting Guide
impact: REFERENCE
impactDescription: 자주 발생하는 오류와 해결 방법
tags: [navermap, troubleshooting, build-error, ios, android, expo, clustering]
---

# Troubleshooting Guide

## 지도가 표시되지 않는 경우

### 클라이언트 ID 미설정

가장 흔한 원인입니다. 네이버 지도 API 클라이언트 ID를 등록해야 합니다.

**iOS (Info.plist):**
```xml
<key>NMFClientId</key>
<string>YOUR_CLIENT_ID_HERE</string>
```

**Android (AndroidManifest.xml):**
```xml
<application>
  <meta-data
    android:name="com.naver.maps.map.CLIENT_ID"
    android:value="YOUR_CLIENT_ID_HERE" />
</application>
```

주의: 클라이언트 ID 앞뒤 공백이 포함되지 않도록 확인하세요.

### 스타일 미지정

NaverMapView에 크기를 지정하지 않으면 렌더링되지 않습니다.

```tsx
// 잘못된 예
<NaverMapView />

// 올바른 예 - flex 사용
<NaverMapView style={{ flex: 1 }} />

// 올바른 예 - 고정 크기 사용
<NaverMapView style={{ width: '100%', height: 300 }} />
```

### 초기화 미완료

`onInitialized` 콜백이 호출되지 않으면 네이티브 빌드 설정을 검토하세요.

```tsx
<NaverMapView
  onInitialized={() => {
    console.log('지도 초기화 완료');
    // 초기화 후 ref 메서드 사용 가능
  }}
/>
```

---

## iOS 빌드 오류

### pod install 실패

Podfile에 네이버 지도 저장소 소스를 추가해야 합니다.

```ruby
# ios/Podfile
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/NaverMapSDK/pod-spec.git'
```

캐시 초기화 후 재설치:
```bash
cd ios
pod cache clean --all
pod install
```

### Bitcode 오류

Xcode 빌드 설정에서 Bitcode를 비활성화해야 합니다.

1. Xcode에서 프로젝트 선택
2. Build Settings 탭 → "Enable Bitcode" 검색
3. 값을 **No**로 변경

### New Architecture에서 커스텀 마커 뷰 미표시

New Architecture(Fabric) 환경에서 커스텀 뷰를 마커 이미지로 사용할 때 렌더링 문제가 발생할 수 있습니다.

```tsx
// 커스텀 마커 뷰의 자식 View에 collapsable={false} 추가
<NaverMapMarkerOverlay latitude={37.5} longitude={127.0}>
  <View collapsable={false} style={{ padding: 8, backgroundColor: 'white' }}>
    <Text>커스텀 마커</Text>
  </View>
</NaverMapMarkerOverlay>
```

---

## Android 빌드 오류

### Maven 저장소 미설정

`android/build.gradle`에 네이버 지도 Maven 저장소를 추가해야 합니다.

```gradle
// android/build.gradle
allprojects {
  repositories {
    google()
    mavenCentral()
    maven {
      url 'https://repository.map.naver.com/archive/maven'
    }
  }
}
```

### SDK 버전 오류

minSdkVersion을 21 이상으로 설정해야 합니다.

```gradle
// android/app/build.gradle
android {
  defaultConfig {
    minSdkVersion 21  // 21 이상 필수
  }
}
```

### 클래스 충돌

다른 지도 라이브러리와 충돌 시 resolutionStrategy를 추가합니다.

```gradle
// android/app/build.gradle
configurations.all {
  resolutionStrategy {
    force 'com.naver.maps:map-sdk:3.19.0'
  }
}
```

---

## 클러스터링 문제

### 탭 이벤트 미작동

`onTapClusterLeaf`는 NaverMapMarkerOverlay가 아닌 NaverMapView에 전달해야 합니다.

```tsx
// 잘못된 예
<NaverMapMarkerOverlay onTapClusterLeaf={...} />  // 작동 안 함

// 올바른 예
<NaverMapView
  onTapClusterLeaf={(marker) => {
    console.log('클러스터 내 마커 탭:', marker.identifier);
  }}
>
  {markers.map(m => (
    <NaverMapMarkerOverlay key={m.id} identifier={m.id} ... />
  ))}
</NaverMapView>
```

### 클러스터링 미작동

- 줌 레벨 범위(minZoom ~ maxZoom)가 올바르게 설정되어 있는지 확인하세요.
- 마커 간 `screenDistance`(화면 픽셀 거리) 값을 확인하세요. 값이 너무 크면 클러스터링이 안 될 수 있습니다.
- 마커에 `identifier`가 반드시 지정되어야 클러스터링이 동작합니다.

```tsx
<NaverMapMarkerOverlay
  identifier="marker-1"  // 필수
  latitude={37.5}
  longitude={127.0}
  minZoom={5}
  maxZoom={15}
/>
```

---

## 카메라 애니메이션 문제

### animateCameraTo 미작동

1. ref가 올바르게 설정되어 있는지 확인하세요.
2. 지도가 초기화된 후에 호출해야 합니다.

```tsx
const mapRef = useRef<NaverMapViewRef>(null);

<NaverMapView
  ref={mapRef}
  onInitialized={() => {
    // onInitialized 이후에 ref 메서드 호출 가능
    mapRef.current?.animateCameraTo({
      latitude: 37.5665,
      longitude: 126.9780,
    });
  }}
/>
```

### Props와 메서드 충돌

선언형(`camera` prop)과 명령형(ref 메서드)을 동시에 사용하면 충돌이 발생합니다.

```tsx
// 잘못된 예 — 둘 다 사용
<NaverMapView
  camera={{ latitude: 37.5, longitude: 127.0, zoom: 14 }}  // 선언형
/>
// 동시에 ref.current?.animateCameraTo(...) 호출  // 명령형

// 올바른 예 — 하나만 사용
// 방법 1: 선언형만 사용
<NaverMapView camera={cameraState} />

// 방법 2: 명령형만 사용 (initialCamera로 초기값 설정)
<NaverMapView initialCamera={{ latitude: 37.5, longitude: 127.0, zoom: 14 }} />
// 이후 ref 메서드로만 카메라 제어
```

---

## Expo 관련

### Expo Go 미지원

`@boostbrothers/react-native-naver-map`은 네이티브 코드를 포함하므로 Expo Go에서 실행할 수 없습니다.

```bash
# Development Build 사용
npx expo run:ios
npx expo run:android
```

### Config Plugin 설정

`app.json`에 플러그인 설정 후 prebuild를 실행해야 합니다.

```json
// app.json
{
  "expo": {
    "plugins": [
      [
        "@boostbrothers/react-native-naver-map",
        {
          "clientId": "YOUR_NAVER_MAP_CLIENT_ID"
        }
      ]
    ]
  }
}
```

```bash
npx expo prebuild --clean
npx expo run:ios
```

---

## 알려진 제한사항

| 제한사항 | 설명 |
|----------|------|
| 커스텀 마커 이미지 캐싱 | 커스텀 뷰를 마커로 사용할 때 이미지 캐싱을 지원하지 않음 |
| Android fpsLimit | 지도 초기화 시점에만 적용됨. 런타임 변경 불가 |
| Android TextureView | 초기화 시점에만 설정 가능 |
| 라이트 모드 | `isLiteModeEnabled` 활성화 시 레이어 그룹, 실내지도, 야간 모드 사용 불가 |
| HTTP 이미지 커스텀 헤더 | `httpUri`의 커스텀 헤더(`headers`) 미지원 |
| 오버레이 최대 개수 | 대량(수천 개)의 오버레이 사용 시 성능 저하 가능. 클러스터링 사용 권장 |
