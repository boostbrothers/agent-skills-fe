---
title: Use High-Performance Modals and Bottom Sheets
impact: HIGH
impactDescription: native performance, gestures, accessibility
tags: modals, bottom-sheet, native, react-navigation, gorhom
---

## Use High-Performance Modals and Bottom Sheets

For modals and bottom sheets, use either native `<Modal>` with `presentationStyle="formSheet"`, React Navigation v7's native form sheet, or `@gorhom/bottom-sheet` for advanced bottom sheet features. Avoid basic JS-based implementations.

**Recommended options:**
- Native Modal with formSheet - Best for simple modals
- React Navigation form sheet - Best for navigation-based modals  
- `@gorhom/bottom-sheet` - Best for complex bottom sheets with snap points, backdrops, and advanced gestures

**Incorrect (basic JS-based bottom sheet without performance optimizations):**

```tsx
import BottomSheet from 'custom-js-bottom-sheet'

function MyScreen() {
  const sheetRef = useRef<BottomSheet>(null)

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => sheetRef.current?.expand()} title='Open' />
      <BottomSheet ref={sheetRef} snapPoints={['50%', '90%']}>
        <View>
          <Text>Sheet content</Text>
        </View>
      </BottomSheet>
    </View>
  )
}
```

**Correct - Option 1 (native Modal with formSheet):**

Best for simple modals without complex gestures or snap points.

```tsx
import { Modal, View, Text, Button, useState } from 'react-native'

function MyScreen() {
  const [visible, setVisible] = useState(false)

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => setVisible(true)} title='Open' />
      <Modal
        visible={visible}
        presentationStyle='formSheet'
        animationType='slide'
        onRequestClose={() => setVisible(false)}
      >
        <View>
          <Text>Sheet content</Text>
        </View>
      </Modal>
    </View>
  )
}
```

**Correct - Option 2 (React Navigation v7 native form sheet):**

Best for navigation-based modals with native transitions.

```tsx
// In your navigator
<Stack.Screen
  name='Details'
  component={DetailsScreen}
  options={{
    presentation: 'formSheet',
    sheetAllowedDetents: 'fitToContents',
  }}
/>
```

**Correct - Option 3 (@gorhom/bottom-sheet):**

Best for complex bottom sheets with snap points, backdrops, and advanced gestures. Built on Reanimated and Gesture Handler for native-level performance.

```tsx
import BottomSheet, { BottomSheetView } from '@gorhom/bottom-sheet'
import { useRef, useMemo } from 'react'

function MyScreen() {
  const sheetRef = useRef<BottomSheet>(null)
  const snapPoints = useMemo(() => ['25%', '50%', '90%'], [])

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => sheetRef.current?.expand()} title='Open' />
      <BottomSheet
        ref={sheetRef}
        index={-1}
        snapPoints={snapPoints}
        enablePanDownToClose
        backdropComponent={BottomSheetBackdrop}
      >
        <BottomSheetView>
          <Text>Sheet content</Text>
        </BottomSheetView>
      </BottomSheet>
    </View>
  )
}
```

**With @gorhom/bottom-sheet - advanced features:**

```tsx
import BottomSheet, { 
  BottomSheetView, 
  BottomSheetBackdrop,
  BottomSheetScrollView 
} from '@gorhom/bottom-sheet'

function MyScreen() {
  const sheetRef = useRef<BottomSheet>(null)
  const snapPoints = useMemo(() => ['25%', '50%', '90%'], [])

  const renderBackdrop = useCallback(
    (props: any) => (
      <BottomSheetBackdrop
        {...props}
        disappearsOnIndex={-1}
        appearsOnIndex={0}
      />
    ),
    []
  )

  return (
    <BottomSheet
      ref={sheetRef}
      index={-1}
      snapPoints={snapPoints}
      enablePanDownToClose
      backdropComponent={renderBackdrop}
      handleIndicatorStyle={{ backgroundColor: '#999' }}
      backgroundStyle={{ backgroundColor: '#fff' }}
    >
      <BottomSheetScrollView>
        <Text>Scrollable sheet content</Text>
      </BottomSheetScrollView>
    </BottomSheet>
  )
}
```

**Key benefits of @gorhom/bottom-sheet:**
- 60fps animations via Reanimated (runs on UI thread)
- Native-like gestures via Gesture Handler
- Multiple snap points with smooth transitions
- Built-in backdrop support
- Keyboard handling
- Scrollable content support
- Accessibility out of the box
- Haptic feedback

Native modals and high-performance bottom sheets provide swipe-to-dismiss, proper keyboard avoidance, and accessibility out of the box.

Reference: [gorhom/bottom-sheet](https://gorhom.dev/react-native-bottom-sheet/)
