---
title: Component API Reference
impact: REFERENCE
impactDescription: 10개 오버레이 컴포넌트의 Props, 메서드, 이벤트 상세
tags: [navermap, component, props, overlay, marker, path, polygon, circle, infowindow]
---

# Component API Reference

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
