# Figma ddocdoc Design System

**Version 1.0.0**  
ddocdoc  
February 2026

> **Note:**  
> This document is mainly for agents and LLMs to follow when maintaining,  
> generating, or refactoring ddocdoc-app React Native design system. Humans  
> may also find it useful, but guidance here is optimized for automation  
> and consistency by AI-assisted workflows.

---

## Abstract

ddocdoc-app React Native 프로젝트의 디자인 시스템 레퍼런스. 피그마 컴포넌트명과 코드 컴포넌트의 매핑, NativeWind 컬러 토큰 사용 규칙, 스타일링 컨벤션을 포함합니다.

---

## Table of Contents

1. [Color & Styling](#1-color-&-styling) — **CRITICAL**
   - 1.1 [Color & Styling Conventions](#11-color--styling-conventions)
2. [Component Mapping](#2-component-mapping) — **HIGH**
   - 2.1 [Component Mapping Reference](#21-component-mapping-reference)

---

## 1. Color & Styling

**Impact: CRITICAL**

NativeWind 컬러 토큰 사용법, lineHeight 오버라이드, inline style 예외 규칙. 모든 피그마 디자인의 색상은 이 토큰 체계를 따라 코드로 변환됩니다.

### 1.1 Color & Styling Conventions

**Impact: CRITICAL (디자인 시스템 색상 및 스타일 일관성의 기반)**

inline `style={{ backgroundColor/color }}` 대신 NativeWind 클래스를 사용한다. 컬러는 반드시 colors.ts에 정의된 토큰을 NativeWind className 패턴으로 참조한다.

**Token Reference:**

```typescript
White: #FFFFFF
Yellow:      700 #FFDB00 | 450 #FFE43F | 400 #FFED49 | 100 #FFF8B6 | 50 #FFFBDB
CoolGray:    900 #2C3744 | 850 #36475A | 800 #506073 | 700 #5F6972 | 500 #80878F
             400 #959BA1 | 300 #ABAFB4 | 200 #E5E8EB | 100 #EDF0F3 | 50 #F5F7F9 | 10 #FBFCFD
NeutralGray: 900 #303133 | 400 #939393 | 300 #AFAFAF | 100 #DFDFDF | 50 #E5E5E5
FeedBackColor: 300 #F55251 | 200 #F75E5F | 100 #FD857C | 50 #FFC5C0 | 10 #FFF0EF
Blue:        300 #0077D1 | 50 #E7F6FF | 10 #F4FBFF
Green:       300 #77C700 | 50 #EDFAD0
DimmedEffect: 40 rgba(0,0,0,0.4) | 4 rgba(0,0,0,0.04)
```

**NativeWind Class Patterns:**

```typescript
배경색: bg-{ColorName}-{shade}     예: bg-Yellow-400, bg-CoolGray-50
텍스트: text-{ColorName}-{shade}   예: text-CoolGray-900, text-Blue-300
보더:   border-{ColorName}-{shade} 예: border-CoolGray-200
흰색:   bg-white, text-white
```

**Incorrect:**

```tsx
// hex 값 직접 사용 금지
<View style={{ backgroundColor: '#FFDB00' }} />
<Text style={{ color: '#2C3744' }} />
<View style={{ borderColor: '#E5E8EB' }} />
```

**Correct:**

```tsx
// NativeWind 토큰 클래스 사용
<View className="bg-Yellow-700" />
<Text className="text-CoolGray-900" />
<View className="bg-CoolGray-50 border border-CoolGray-200" />
<Text className="text-Blue-300" />
<View className="bg-white" />
```

**LineHeight Override:**

```tsx
// 텍스트 스타일 클래스는 lineHeight를 포함한다.
// 피그마 디자인의 lineHeight가 클래스 기본값과 다르면 leading-[Xpx]로 오버라이드한다.

// Caption12Regular(12px/20px)인데 피그마에서 lineHeight가 16px인 경우
<Text className="text-Caption12Regular leading-[16px]" />

// Body14Regular(14px/22px)인데 피그마에서 lineHeight가 18px인 경우
<Text className="text-Body14Regular leading-[18px]" />

// 피그마 lineHeight와 클래스 기본값이 동일하면 오버라이드 불필요
<Text className="text-Body16Regular" />
```

**Allowed: tintColor**

```tsx
// Image 컴포넌트의 tintColor — RN 전용 속성, NativeWind 미지원
<Image style={{ tintColor: Colors.White }} source={icon} />
<Image style={{ tintColor: isOwn ? Colors.Blue[300] : Colors.CoolGray[500] }} source={icon} />
```

**Allowed: animation**

```tsx
// Reanimated animated style — NativeWind와 혼용 불가
const animatedStyle = useAnimatedStyle(() => ({
  opacity: withTiming(isVisible.value ? 1 : 0),
  transform: [{ translateY: withSpring(offsetY.value) }],
}))

<Animated.View style={animatedStyle} className="bg-white" />
```

---

## 2. Component Mapping

**Impact: HIGH**

피그마 컴포넌트명에서 코드 컴포넌트로의 매핑. 버튼, 팝업/알럿, 입력 필드, 바텀시트, 네비게이션, 선택 컨트롤 등 주요 UI 요소의 props와 사용 예시를 포함합니다.

### 2.1 Component Mapping Reference

**Impact: HIGH (피그마 컴포넌트명과 코드 컴포넌트의 일관된 매핑)**

피그마에서 재사용 컴포넌트가 보이면 직접 구현하지 말고 기존 컴포넌트를 사용한다.

**Button Mapping:**

```typescript
SolidButton (~components/common/SolidButton)
  RN/resize button/yellow  →  type="yellow"
  RN/resize button/gray    →  type="gray"
  RN/resize button/line    →  type="line"
  RN/full button/yellow    →  type="yellow" fill
  RN/full button/gray      →  type="gray" fill
  RN/full button/line      →  type="line" fill

  Props:
    type: 'yellow' | 'gray' | 'line'  (default: 'yellow')
    size: 'large' | 'medium' | 'small'  (default: 'large')
    title: 버튼 텍스트
    fill: true면 100% 너비
    originWidth: true면 내용 너비만큼 alignSelf: 'center'
    icon / iconStyle: 이미지 아이콘
    iconComponent: ReactNode 아이콘
    iconPosition: 'left' | 'right'  (default: 'left')
    disabled: 비활성화 (opacity 0.4)
    onDisabledPress: disabled 상태에서도 클릭 이벤트

FilterButton (~components/common/FilterButton)
  RN/filter  →  title(선택된 값) 또는 placeholder(미선택)

  Props:
    title?: 선택된 값 텍스트
    placeholder?: 선택 전 안내 텍스트 (회색)
    onPress: 필터 선택 시트 열기
```

**SolidButton Usage:**

```tsx
import SolidButton from '~components/common/SolidButton';

<SolidButton type="yellow" title="확인" onPress={handlePress} />
<SolidButton type="gray" fill title="취소" onPress={handleCancel} />
<SolidButton type="line" title="공유" icon={SHARE_ICON} iconPosition="left" />
<SolidButton type="yellow" title="저장" disabled onPress={handlePress} />
```

**FilterButton Usage:**

```tsx
import FilterButton from '~components/common/FilterButton';

<FilterButton placeholder="진료과" title={selectedDept} onPress={openDeptSheet} />
```

**Popup Mapping:**

```typescript
SimplePopup (~components/common/overlays/popups/SimplePopup)
  RN/popup (1버튼)  →  ctaText, onCtaPress
  RN/popup (2버튼)  →  ctaText, onCtaPress, secondaryCtaText, onSecondaryCtaPress

  Props:
    title?: 팝업 제목 (선택)
    content: 팝업 본문 텍스트 (ReactNode)
    ctaText: 주요 버튼 텍스트  (default: '확인')
    onCtaPress?: 주요 버튼 클릭 콜백
    secondaryCtaText?: 보조 버튼 텍스트 (있으면 2버튼 레이아웃)
    onSecondaryCtaPress?: 보조 버튼 클릭 콜백

  usePopup 훅의 showPopup으로 표시. hidePopup은 내부에서 자동 호출.

BaseSnackbar (~components/common/overlays/BaseSnackBar)
  RN/snackbar  →  하단에 잠깐 표시되는 토스트 메시지

  Props:
    isVisible: boolean
    message: string  (줄바꿈 \n 지원, 최대 2줄)
    actionText?: 우측 액션 버튼 텍스트 (Yellow 색상)
    onActionPress?: 액션 버튼 클릭 콜백
    duration?: 자동 닫힘 ms  (default: 3000, Infinity로 수동 닫기)
    showDismissIcon?: X 버튼 표시
    bottomOffset?: 하단 여백  (default: 24)
    isShowTabScreen?: 탭바 있는 화면이면 true

  useSnackbar 훅을 통해 표시.
```

**SimplePopup Usage:**

```tsx
import SimplePopup from '~components/common/overlays/popups/SimplePopup';
import usePopup from '~hooks/usePopup';

const { showPopup } = usePopup();

showPopup({
  element: (
    <SimplePopup
      content="메시지를 삭제 하시겠습니까?"
      secondaryCtaText="취소"
      ctaText="삭제"
      onCtaPress={() => { /* 확인 액션 */ }}
    />
  ),
  backdrop: true,
});
```

**BaseSnackbar Usage:**

```tsx
import BaseSnackbar from '~components/common/overlays/BaseSnackBar';
import useSnackbar from '~hooks/useSnackbar';

const { openSnackbar, snackbarState, hideSnackbar } = useSnackbar();

openSnackbar({ message: '저장되었습니다.' });
openSnackbar({ message: '링크가 복사되었습니다.', actionText: '확인', onActionPress: handleAction });

<BaseSnackbar isVisible={snackbarState.isVisible} message={snackbarState.message} onDismiss={hideSnackbar} />
```

**Input Mapping:**

```typescript
BaseTextInput (~components/common/BaseTextInput)
  RN/TextField/OneLine       →  기본값 (bordered=true)
  RN/TextField/OneLine_unit  →  기본값 + 외부에서 단위 텍스트 배치
  RN/TextField/Long          →  multiline={true} textAlignVertical="top"
  RN/TextField/Noline        →  bordered={false}

  Props (RN TextInputProps 확장):
    bordered?: boolean  (default: true)  false면 테두리 없는 스타일
    resetable?: boolean  true면 포커스 시 우측에 X 버튼
    bold?: boolean  true면 볼드체 (Pretendard-Bold, 20px)
    isUIEditable?: boolean  UI 편집 가능 여부 (배경색 제어)
    + 표준 TextInputProps: value, onChangeText, placeholder, multiline 등

SSNBackNumberPadBottomSheet (~components/common/SSNBackNumberPadBottomSheet)
  RN/TextField/주민번호  →  주민번호 뒷자리 입력 전용 보안 키패드 시트

  Props:
    isVisible: boolean
    frontNumber: string  (주민번호 앞자리, 유효성 검증에 사용)
    isIgnoreSsnChecksum?: boolean  체크섬 검증 무시
    onComplete: (values: number[]) => void  7자리 입력 완료 콜백
    onValidateError: (error: SSNValidationErrorType) => void  유효성 오류 콜백
```

**BaseTextInput Usage:**

```tsx
import BaseTextInput from '~components/common/BaseTextInput';

<BaseTextInput value={name} onChangeText={setName} placeholder="이름 입력" resetable />
<BaseTextInput value={content} onChangeText={setContent} multiline textAlignVertical="top" style={{ height: 120 }} />
<BaseTextInput bordered={false} value={search} onChangeText={setSearch} placeholder="검색어 입력" />
```

**SSNBackNumberPadBottomSheet Usage:**

```tsx
import SSNBackNumberPadBottomSheet from '~components/common/SSNBackNumberPadBottomSheet';

<SSNBackNumberPadBottomSheet
  isVisible={isSSNPadVisible}
  frontNumber={ssnFront}
  onComplete={(values) => { setSsnBack(values.join('')); setIsSSNPadVisible(false); }}
  onValidateError={() => { openSnackbar({ message: '주민번호를 확인해주세요.' }); }}
/>
```

**BottomSheet Mapping:**

```typescript
BaseBottomSheet (~components/common/overlays/BaseBottomSheet)
  RN / Sheet  →  하단에서 슬라이드 업되는 범용 시트

  Props:
    isVisible: boolean
    content: ReactNode  (시트 본문, 스크롤 가능)
    bottomSheetTitle?: string  시트 상단 제목
    isShowCloseButton?: boolean  (default: true)
    onClose?: () => void
    backdrop?: boolean  (default: true)  배경 터치로 닫기
    keepState?: boolean  true면 닫을 때 내부 상태 유지
    actionButtonProps?: SolidButtonProps  하단 확인 버튼
    actionCancelButtonProps?: SolidButtonProps  하단 취소 버튼 (gray type 자동)
    stickyHeaderComponent?: ReactNode
    stickyFooterComponent?: ReactNode
    removeHeaderBlock?: boolean
    removeBottomBlock?: boolean
    useKeyboardAnimation?: boolean  (default: true)

  useBottomSheet 훅을 통해 표시.
```

**BaseBottomSheet Usage:**

```tsx
import BaseBottomSheet from '~components/common/overlays/BaseBottomSheet';
import useBottomSheet from '~hooks/useBottomSheet';

const { openBottomSheet } = useBottomSheet();

openBottomSheet({
  bottomSheetTitle: '필터',
  content: <FilterContent />,
  actionButtonProps: { title: '적용', onPress: applyFilter },
  actionCancelButtonProps: { title: '초기화', onPress: resetFilter },
});

// keepState로 직접 제어
<BaseBottomSheet isVisible={isVisible} keepState content={<MyContent />} onClose={() => setIsVisible(false)} />
```

**Header Mapping:**

```typescript
NavButtonTitleHeader (~components/common/HeaderScreenContainer/NavButtonTitleHeader)
  RN / title  →  뒤로가기(또는 닫기) + 제목 + 우측 버튼을 포함한 헤더

  Props:
    type?: 'backward' | 'dismiss'  (default: 'backward')
      backward: ← 아이콘, Android 뒤로가기 동작
      dismiss:  X 아이콘, 모달 닫기 동작
    headerTitle?: 헤더 중앙 제목 텍스트
    hasUnderline?: boolean  (default: false)
    rightButton?: ReactNode  우측 커스텀 버튼/컴포넌트
    leftButtonHandler?: () => Promise<void>  커스텀 핸들러 (없으면 router.back())
    showLeftButton?: boolean  (default: true)
```

**NavButtonTitleHeader Usage:**

```tsx
import NavButtonTitleHeader from '~components/common/HeaderScreenContainer/NavButtonTitleHeader';

<NavButtonTitleHeader headerTitle="상세보기" />
<NavButtonTitleHeader type="dismiss" headerTitle="설정" rightButton={<TextButton title="저장" onPress={handleSave} />} />
<NavButtonTitleHeader headerTitle="편집" leftButtonHandler={async () => { await confirmLeave(); router.back(); }} />
```

**Selection Mapping:**

```typescript
Checkbox (~components/common/Checkbox)
  Checkbox           →  type="default"
  label/Checkbox     →  type="default" + title
  Radio              →  type="radio"
  label/Radio        →  type="radio" + title
  RadioCheck         →  type="solidRadio"
  RadioCheck2        →  type="solidRadio"
  label/RadioCheck   →  type="solidRadio" + title

  Props:
    type?: 'default' | 'radio' | 'solidRadio'  (default: 'default')
    isChecked: boolean
    title: string
    typography?: TypographyType  (default: 'title1')
    onPress: 선택 시 콜백
```

**Checkbox Usage:**

```tsx
import Checkbox from '~components/common/Checkbox';

<Checkbox type="default" isChecked={isAgreed} title="이용약관에 동의합니다" onPress={() => setIsAgreed(prev => !prev)} />
<Checkbox type="radio" isChecked={selectedOption === 'A'} title="옵션 A" onPress={() => setSelectedOption('A')} />
<Checkbox type="solidRadio" isChecked={selectedGender === 'male'} title="남성" onPress={() => setSelectedGender('male')} />
```

---

