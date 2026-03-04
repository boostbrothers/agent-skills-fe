# React Native Naver Map

**Version 1.0.0**
ddocdoc
March 2026

> **Note:**
> This document is for agents and LLMs to follow when working with
> @boostbrothers/react-native-naver-map. Humans may also find it useful.

---

## Abstract

네이버 지도 SDK를 React Native에서 사용할 수 있도록 래핑한 라이브러리. 10개 오버레이 컴포넌트, 카메라 제어, 마커 클러스터링, 위치 추적 기능을 포함합니다.

---

## Table of Contents

1. [Component API](#1-component-api) — **REFERENCE**
   - 1.1 [Component API Reference](#11-component-api-reference)
2. [Types & Enums](#2-types--enums) — **REFERENCE**
   - 2.1 [Types & Enums Reference](#21-types--enums-reference)
3. [Troubleshooting](#3-troubleshooting) — **REFERENCE**
   - 3.1 [Troubleshooting Guide](#31-troubleshooting-guide)

---

## 1. Component API

### 1.1 Component API Reference

## NaverMapView

지도를 렌더링하는 메인 컴포넌트. `style` prop은 반드시 지정해야 합니다.

```tsx
import { NaverMapView, NaverMapViewRef } from '@boostbrothers/react-native-naver-map';

const mapRef = useRef<NaverMapViewRef>(null);

<NaverMapView
  ref={mapRef}
  style={{ flex: 1 }}
  mapType="Basic"
  initialCamera={{ latitude: 37.5665, longitude: 126.9780, zoom: 14 }}
  onInitialized={() => console.log('지도 초기화 완료')}
/>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| mapType | MapType | 지도 유형 (기본값: "Basic") |
| initialCamera | Camera | 초기 카메라 위치 (마운트 시 1회 적용) |
| camera | Camera | 선언형 카메라 제어 (변경 시마다 적용) |
| region | Region | 지도 표시 영역 |
| isIndoorEnabled | boolean | 실내지도 활성화 |
| isNightModeEnabled | boolean | 야간 모드 활성화 |
| isLiteModeEnabled | boolean | 라이트 모드 활성화 (레이어/실내/야간 사용 불가) |
| isShowCompass | boolean | 나침반 표시 여부 |
| isShowScaleBar | boolean | 축척바 표시 여부 |
| isShowZoomControls | boolean | 줌 컨트롤 표시 여부 |
| isShowIndoorLevelPicker | boolean | 실내지도 층 선택 UI 표시 |
| isShowLocationButton | boolean | 내 위치 버튼 표시 여부 |
| logoAlign | LogoAlign | 네이버 로고 위치 |
| logoMargin | Rect | 로고 여백 |
| lightness | number | 지도 밝기 (-1 ~ 1) |
| buildingHeight | number | 건물 3D 높이 (0 ~ 1) |
| symbolScale | number | 심벌 크기 배율 |
| symbolPerspectiveRatio | number | 심벌 원근 효과 비율 |
| mapPadding | Rect | 지도 패딩 |
| fpsLimit | number | 최대 FPS 제한 |
| onInitialized | () => void | 지도 초기화 완료 콜백 |
| onOptionChanged | () => void | 지도 옵션 변경 콜백 |
| onCameraChanged | (params) => void | 카메라 변경 콜백 |
| onTapMap | (params) => void | 지도 탭 콜백 (좌표 포함) |
| onTapClusterLeaf | (params) => void | 클러스터 내 마커 탭 콜백 |

### Layer Groups

```tsx
<NaverMapView
  layerGroups={{
    building: true,    // 건물
    traffic: false,    // 교통
    transit: false,    // 대중교통
    bicycle: false,    // 자전거
    mountain: false,   // 등산로
    cadastral: false,  // 지적편집도
  }}
/>
```

### NaverMapViewRef Methods

```tsx
// 특정 좌표로 카메라 이동
mapRef.current?.animateCameraTo({
  latitude: 37.5665,
  longitude: 126.9780,
  zoom: 14,
  duration: 1000,
  easing: 'EaseOut',
});

// 현재 위치에서 상대적 이동
mapRef.current?.animateCameraBy({
  x: 100,
  y: 50,
  duration: 500,
});

// 특정 영역으로 이동
mapRef.current?.animateRegionTo({
  latitude: 37.5665,
  longitude: 126.9780,
  latitudeDelta: 0.05,
  longitudeDelta: 0.05,
  duration: 1000,
});

// 두 좌표가 모두 보이도록 자동 줌
mapRef.current?.animateCameraWithTwoCoords({
  coord1: { latitude: 37.5, longitude: 126.9 },
  coord2: { latitude: 37.6, longitude: 127.0 },
  duration: 1000,
});

// 애니메이션 취소
mapRef.current?.cancelAnimation();

// 위치 추적 모드 설정
mapRef.current?.setLocationTrackingMode('Follow');

// 화면 좌표 → 위경도 변환
const coord = await mapRef.current?.screenToCoordinate({ x: 100, y: 200 });

// 위경도 → 화면 좌표 변환
const point = await mapRef.current?.coordinateToScreen({ latitude: 37.5, longitude: 127.0 });
```

---

## NaverMapMarkerOverlay

지도 위에 마커를 표시하는 컴포넌트.

```tsx
import { NaverMapMarkerOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapMarkerOverlay
    latitude={37.5665}
    longitude={126.9780}
    width={30}
    height={40}
    image={require('./assets/marker.png')}
    caption={{ text: '서울시청', textSize: 14 }}
    onTap={() => console.log('마커 탭')}
  />
</NaverMapView>
```

### Props

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| latitude | number | 필수 | 위도 |
| longitude | number | 필수 | 경도 |
| image | MapImageProp | - | 마커 이미지 |
| width | number | - | 마커 너비 (dp) |
| height | number | - | 마커 높이 (dp) |
| anchor | Point | - | 이미지 앵커 포인트 (기본값: { x: 0.5, y: 1 }) |
| caption | object | - | 캡션 설정 (text, textSize, color, align 등) |
| subCaption | object | - | 서브 캡션 설정 |
| alpha | number | - | 투명도 (0 ~ 1) |
| isFlat | boolean | - | 지도에 눕히기 여부 |
| isForceShowIcon | boolean | - | 충돌 시에도 강제 표시 |
| isIconPerspectiveEnabled | boolean | - | 원근 효과 적용 |
| isHideCollidedSymbols | boolean | - | 충돌 심벌 숨기기 |
| isHideCollidedMarkers | boolean | - | 충돌 마커 숨기기 |
| isHideCollidedCaptions | boolean | - | 충돌 캡션 숨기기 |
| onTap | () => void | - | 마커 탭 콜백 |

BaseOverlayProps (zIndex, globalZIndex, isHidden, minZoom, maxZoom 등)도 지원합니다.

---

## NaverMapInfoWindow

마커 또는 특정 좌표 위에 정보창(말풍선)을 표시하는 컴포넌트.

```tsx
import { NaverMapInfoWindow } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapInfoWindow
    latitude={37.5665}
    longitude={126.9780}
    text="서울시청"
    textSize={14}
    textColor="#333333"
    backgroundColor="#FFFFFF"
    borderRadius={8}
    isOpen={true}
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| latitude | number | 위도 (필수) |
| longitude | number | 경도 (필수) |
| identifier | string | 고유 식별자 |
| isOpen | boolean | 표시 여부 |
| align | Align | 정렬 방향 |
| anchor | Point | 앵커 포인트 |
| offsetX | number | X 오프셋 |
| offsetY | number | Y 오프셋 |
| alpha | number | 투명도 (0 ~ 1) |
| text | string | 표시 텍스트 |
| textSize | number | 텍스트 크기 |
| textColor | string | 텍스트 색상 |
| fontWeight | string | 폰트 굵기 |
| fontFamily | string | 폰트 패밀리 |
| backgroundColor | string | 배경 색상 |
| borderRadius | number | 모서리 반경 |
| borderWidth | number | 테두리 두께 |
| borderColor | string | 테두리 색상 |
| paddingHorizontal | number | 수평 패딩 |
| paddingVertical | number | 수직 패딩 |

BaseOverlayProps도 지원합니다.

---

## NaverMapPathOverlay

경로선을 표시하는 컴포넌트. 진척률(progress)을 지원하여 지나온 경로와 남은 경로를 다른 색으로 표현할 수 있습니다.

```tsx
import { NaverMapPathOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapPathOverlay
    coords={[
      { latitude: 37.5, longitude: 127.0 },
      { latitude: 37.55, longitude: 127.05 },
      { latitude: 37.6, longitude: 127.1 },
    ]}
    width={5}
    color="#0000FF"
    progress={0.5}
    passedColor="#AAAAAA"
    outlineWidth={2}
    outlineColor="#FFFFFF"
  />
</NaverMapView>
```

### Props

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| coords | Coord[] | 필수 | 경로 좌표 배열 (2개 이상) |
| width | number | - | 선 너비 (dp) |
| outlineWidth | number | - | 외곽선 너비 (dp) |
| color | string | - | 선 색상 |
| outlineColor | string | - | 외곽선 색상 |
| passedColor | string | - | 지나온 경로 색상 |
| passedOutlineColor | string | - | 지나온 경로 외곽선 색상 |
| progress | number | - | 진척률 (0 ~ 1) |
| patternImage | MapImageProp | - | 패턴 이미지 |
| patternInterval | number | - | 패턴 간격 (dp) |
| isHideCollidedSymbols | boolean | - | 충돌 심벌 숨기기 |
| isHideCollidedMarkers | boolean | - | 충돌 마커 숨기기 |
| isHideCollidedCaptions | boolean | - | 충돌 캡션 숨기기 |

BaseOverlayProps도 지원합니다.

---

## NaverMapPolylineOverlay

폴리라인을 표시하는 컴포넌트.

```tsx
import { NaverMapPolylineOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapPolylineOverlay
    coords={[
      { latitude: 37.5, longitude: 127.0 },
      { latitude: 37.6, longitude: 127.1 },
    ]}
    width={3}
    color="#FF0000"
    capType="Round"
    joinType="Round"
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| coords | Coord[] | 좌표 배열 (필수) |
| width | number | 선 너비 (dp) |
| color | string | 선 색상 |
| capType | CapType | 끝점 모양 |
| joinType | JoinType | 연결점 모양 |
| pattern | number[] | 대시 패턴 |

BaseOverlayProps도 지원합니다.

---

## NaverMapPolygonOverlay

다각형 영역을 표시하는 컴포넌트.

```tsx
import { NaverMapPolygonOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapPolygonOverlay
    coords={[
      { latitude: 37.5, longitude: 127.0 },
      { latitude: 37.5, longitude: 127.1 },
      { latitude: 37.6, longitude: 127.1 },
      { latitude: 37.6, longitude: 127.0 },
    ]}
    color="rgba(0,0,255,0.3)"
    outlineWidth={2}
    outlineColor="#0000FF"
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| coords | Coord[] | 외곽 좌표 배열 (필수) |
| holes | Coord[][] | 내부 구멍 좌표 배열들 |
| color | string | 채우기 색상 |
| outlineWidth | number | 외곽선 너비 (dp) |
| outlineColor | string | 외곽선 색상 |

BaseOverlayProps도 지원합니다.

---

## NaverMapCircleOverlay

원형 영역을 표시하는 컴포넌트.

```tsx
import { NaverMapCircleOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapCircleOverlay
    latitude={37.5665}
    longitude={126.9780}
    radius={500}
    color="rgba(0,128,255,0.3)"
    outlineWidth={2}
    outlineColor="#0080FF"
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| latitude | number | 중심 위도 (필수) |
| longitude | number | 중심 경도 (필수) |
| radius | number | 반지름 (미터 단위, 필수) |
| color | string | 채우기 색상 |
| outlineWidth | number | 외곽선 너비 (dp) |
| outlineColor | string | 외곽선 색상 |

BaseOverlayProps도 지원합니다.

---

## NaverMapArrowheadPathOverlay

화살표 머리가 있는 경로선을 표시하는 컴포넌트.

```tsx
import { NaverMapArrowheadPathOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapArrowheadPathOverlay
    coords={[
      { latitude: 37.5, longitude: 127.0 },
      { latitude: 37.55, longitude: 127.05 },
    ]}
    width={10}
    color="#FF6600"
    headSizeRatio={5}
    outlineWidth={1}
    outlineColor="#FFFFFF"
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| coords | Coord[] | 경로 좌표 배열 (필수) |
| width | number | 선 너비 (dp) |
| color | string | 선 색상 |
| headSizeRatio | number | 화살표 머리 크기 비율 |
| outlineWidth | number | 외곽선 너비 (dp) |
| outlineColor | string | 외곽선 색상 |

BaseOverlayProps도 지원합니다.

---

## NaverMapMultiPathOverlay

구간별로 다른 색상을 가지는 다중 경로선을 표시하는 컴포넌트.

```tsx
import { NaverMapMultiPathOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapMultiPathOverlay
    paths={[
      {
        coords: [
          { latitude: 37.5, longitude: 127.0 },
          { latitude: 37.52, longitude: 127.02 },
        ],
        color: '#FF0000',
        outlineColor: '#FFFFFF',
      },
      {
        coords: [
          { latitude: 37.52, longitude: 127.02 },
          { latitude: 37.55, longitude: 127.05 },
        ],
        color: '#00FF00',
        outlineColor: '#FFFFFF',
      },
    ]}
    width={8}
    outlineWidth={2}
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| paths | MultiPathPart[] | 구간 배열 (필수) |
| width | number | 선 너비 (dp) |
| outlineWidth | number | 외곽선 너비 (dp) |

**MultiPathPart:**

| Field | Type | Description |
|-------|------|-------------|
| coords | Coord[] | 구간 좌표 배열 (필수) |
| color | string | 구간 색상 |
| passedColor | string | 지나온 구간 색상 |
| outlineColor | string | 구간 외곽선 색상 |
| passedOutlineColor | string | 지나온 구간 외곽선 색상 |

BaseOverlayProps도 지원합니다.

---

## NaverMapGroundOverlay

특정 지도 영역(바운딩 박스) 위에 이미지를 표시하는 컴포넌트.

```tsx
import { NaverMapGroundOverlay } from '@boostbrothers/react-native-naver-map';

<NaverMapView style={{ flex: 1 }}>
  <NaverMapGroundOverlay
    bounds={{
      northEast: { latitude: 37.6, longitude: 127.1 },
      southWest: { latitude: 37.5, longitude: 127.0 },
    }}
    image={require('./assets/overlay.png')}
    alpha={0.8}
  />
</NaverMapView>
```

### Props

| Prop | Type | Description |
|------|------|-------------|
| bounds | object | 표시 영역 (필수): { northEast: Coord, southWest: Coord } |
| image | MapImageProp | 표시할 이미지 (필수) |
| alpha | number | 투명도 (0 ~ 1) |

BaseOverlayProps도 지원합니다.

---

## 2. Types & Enums

### 2.1 Types & Enums Reference

## Core Interfaces

### Camera

카메라 위치와 뷰를 정의하는 인터페이스.

```ts
interface Camera {
  latitude: number;    // 위도
  longitude: number;   // 경도
  zoom?: number;       // 줌 레벨 (0 ~ 21)
  tilt?: number;       // 기울기 각도 (0 ~ 60)
  bearing?: number;    // 방위각 (0 ~ 360)
}
```

### Coord

위경도 좌표를 나타내는 기본 인터페이스.

```ts
interface Coord {
  latitude: number;   // 위도
  longitude: number;  // 경도
}
```

### Region

지도 표시 영역을 정의하는 인터페이스.

```ts
interface Region {
  latitude: number;       // 중심 위도
  longitude: number;      // 중심 경도
  latitudeDelta: number;  // 위도 범위 (남북 방향 크기)
  longitudeDelta: number; // 경도 범위 (동서 방향 크기)
}
```

### Point

화면 좌표를 나타내는 인터페이스.

```ts
interface Point {
  x: number;  // 화면 X 좌표 (픽셀)
  y: number;  // 화면 Y 좌표 (픽셀)
}
```

### Rect

사각형 여백/패딩을 나타내는 인터페이스.

```ts
interface Rect {
  left: number;
  top: number;
  right: number;
  bottom: number;
}
```

---

## Overlay Interfaces

### BaseOverlayProps

모든 오버레이 컴포넌트가 공통으로 상속하는 Props.

```ts
interface BaseOverlayProps {
  zIndex?: number;               // 오버레이 z-인덱스
  globalZIndex?: number;         // 전역 z-인덱스
  isHidden?: boolean;            // 숨김 여부
  minZoom?: number;              // 최소 표시 줌 레벨
  maxZoom?: number;              // 최대 표시 줌 레벨
  isMinZoomInclusive?: boolean;  // 최소 줌 포함 여부
  isMaxZoomInclusive?: boolean;  // 최대 줌 포함 여부
  onTap?: () => void;            // 탭 이벤트 콜백
}
```

### ClusterMarkerProp

클러스터링에서 개별 마커 정보를 나타내는 인터페이스.

```ts
interface ClusterMarkerProp {
  identifier: string;     // 마커 고유 식별자 (필수)
  image?: MapImageProp;   // 마커 이미지
  width?: number;         // 마커 너비 (dp)
  height?: number;        // 마커 높이 (dp)
  latitude: number;       // 위도 (필수)
  longitude: number;      // 경도 (필수)
}
```

### CameraMoveBaseParams

카메라 애니메이션 공통 파라미터.

```ts
interface CameraMoveBaseParams {
  duration?: number;                // 애니메이션 시간 (밀리초, 기본값: 300)
  easing?: CameraAnimationEasing;   // 이징 함수
  pivot?: Point;                    // 줌 피벗 포인트
}
```

### MultiPathPart

NaverMapMultiPathOverlay에서 각 구간을 정의하는 인터페이스.

```ts
interface MultiPathPart {
  coords: Coord[];             // 구간 좌표 배열 (필수)
  color?: string;              // 구간 선 색상
  passedColor?: string;        // 지나온 구간 색상
  outlineColor?: string;       // 구간 외곽선 색상
  passedOutlineColor?: string; // 지나온 구간 외곽선 색상
}
```

### NaverMapInfoWindowProps

NaverMapInfoWindow 컴포넌트의 전체 Props (BaseOverlayProps + Coord 확장).

```ts
interface NaverMapInfoWindowProps extends BaseOverlayProps {
  // 위치 (필수)
  latitude: number;
  longitude: number;

  // 상태
  identifier?: string;  // 고유 식별자
  isOpen?: boolean;     // 표시 여부

  // 위치 조정
  align?: Align;        // 정렬 방향
  anchor?: Point;       // 앵커 포인트
  offsetX?: number;     // X 오프셋 (dp)
  offsetY?: number;     // Y 오프셋 (dp)
  alpha?: number;       // 투명도 (0 ~ 1)

  // 텍스트
  text?: string;         // 표시 텍스트
  textSize?: number;     // 텍스트 크기 (sp)
  textColor?: string;    // 텍스트 색상
  fontWeight?: string;   // 폰트 굵기 ('bold', 'normal' 등)
  fontFamily?: string;   // 폰트 패밀리

  // 스타일
  backgroundColor?: string;   // 배경 색상
  borderRadius?: number;       // 모서리 반경 (dp)
  borderWidth?: number;        // 테두리 두께 (dp)
  borderColor?: string;        // 테두리 색상
  paddingHorizontal?: number;  // 수평 패딩 (dp)
  paddingVertical?: number;    // 수직 패딩 (dp)
}
```

---

## Union Types (Enums)

### MapType

지도 유형.

```ts
type MapType =
  | 'Basic'      // 일반 지도
  | 'Navi'       // 내비게이션 지도
  | 'Satellite'  // 위성 지도
  | 'Hybrid'     // 위성+일반 혼합
  | 'Terrain'    // 지형도
  | 'NaviHybrid' // 내비게이션+위성 혼합
```

### LocationTrackingMode

위치 추적 모드.

```ts
type LocationTrackingMode =
  | 'None'      // 위치 추적 끔
  | 'NoFollow'  // 위치만 표시 (카메라 추적 없음)
  | 'Follow'    // 위치 표시 + 카메라 자동 추적
  | 'Face'      // 위치 표시 + 방향 포함 카메라 추적
```

### CameraAnimationEasing

카메라 애니메이션 이징 함수.

```ts
type CameraAnimationEasing =
  | 'None'     // 이징 없음 (즉시 이동)
  | 'Fly'      // 비행 효과
  | 'Linear'   // 선형
  | 'EaseIn'   // 느리게 시작
  | 'EaseOut'  // 느리게 끝
```

### CameraChangeReason

카메라 변경 원인. `onCameraChanged` 콜백의 파라미터로 전달됩니다.

```ts
type CameraChangeReason =
  | 'Developer'  // 개발자 코드에 의한 변경
  | 'Gesture'    // 사용자 제스처에 의한 변경
  | 'Control'    // 컨트롤 버튼에 의한 변경
  | 'Location'   // 위치 추적에 의한 변경
```

### CapType

폴리라인 끝점 모양.

```ts
type CapType =
  | 'Butt'    // 평평하게 자른 끝점
  | 'Round'   // 둥근 끝점
  | 'Square'  // 사각형 끝점
```

### JoinType

폴리라인 연결점 모양.

```ts
type JoinType =
  | 'Miter'  // 뾰족한 연결점
  | 'Round'  // 둥근 연결점
  | 'Bevel'  // 사선으로 자른 연결점
```

### LogoAlign

네이버 지도 로고 위치.

```ts
type LogoAlign =
  | 'LeftBottom'   // 왼쪽 하단 (기본값)
  | 'LeftTop'      // 왼쪽 상단
  | 'RightBottom'  // 오른쪽 하단
  | 'RightTop'     // 오른쪽 상단
```

### Align

캡션 및 정보창 정렬 방향.

```ts
type Align =
  | 'Center' // 중앙
  | 'Left'   // 왼쪽
  | 'Right'  // 오른쪽
  | 'Top'    // 위
  | 'Bottom' // 아래
  | 'TopLeft'     // 왼쪽 위
  | 'TopRight'    // 오른쪽 위
  | 'BottomLeft'  // 왼쪽 아래
  | 'BottomRight' // 오른쪽 아래
```

### MarkerSymbol

네이버 기본 제공 마커 심벌 종류. `image` prop에 사용합니다.

```ts
type MarkerSymbol =
  | 'GREEN'
  | 'RED'
  | 'BLUE'
  | 'YELLOW'
  | 'PINK'
  | 'GRAY'
  | 'BLACK'
```

### MapImageProp

마커 및 오버레이에서 사용하는 이미지 타입. 다양한 소스를 지원합니다.

```ts
type MapImageProp =
  | number                              // require('./image.png') — 로컬 이미지
  | { uri: string }                     // 네트워크 이미지 (HTTP/HTTPS)
  | { symbol: MarkerSymbol }            // 네이버 기본 심벌
  | { httpUri: string; headers?: Record<string, string> }  // HTTP 이미지 (헤더 주의: 미지원)
```

**사용 예시:**

```tsx
// 로컬 이미지
<NaverMapMarkerOverlay image={require('./assets/marker.png')} ... />

// 네트워크 이미지
<NaverMapMarkerOverlay image={{ uri: 'https://example.com/marker.png' }} ... />

// 네이버 기본 심벌
<NaverMapMarkerOverlay image={{ symbol: 'RED' }} ... />
```

---

## 3. Troubleshooting

### 3.1 Troubleshooting Guide

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
