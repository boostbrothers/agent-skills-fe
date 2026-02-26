---
title: Component Mapping Reference
impact: HIGH
impactDescription: 피그마 컴포넌트명과 코드 컴포넌트의 일관된 매핑
tags: [component, button, popup, input, bottomsheet, navigation, checkbox, figma]
---

## Component Mapping Reference

**Impact: HIGH**

피그마에서 재사용 컴포넌트가 보이면 직접 구현하지 말고 기존 컴포넌트를 사용한다.

**Button Mapping:**

```
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

```
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

```
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

```
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

```
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

```
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
