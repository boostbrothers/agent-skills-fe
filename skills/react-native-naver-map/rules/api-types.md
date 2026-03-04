---
title: Types & Enums Reference
impact: REFERENCE
impactDescription: 모든 인터페이스, 타입 별칭, 열거형 정의
tags: [navermap, types, enums, camera, coord, region, interface]
---

# Types & Enums Reference

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
