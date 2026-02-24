---
title: Control Non-Style Props on UI Thread with useAnimatedProps
impact: HIGH
impactDescription: eliminates re-renders for UI prop changes
tags: animation, reanimated, useAnimatedProps, re-render, performance
---

## Control Non-Style Props on UI Thread with useAnimatedProps

Use `useAnimatedProps` with `Animated.createAnimatedComponent` to control
non-style UI props (`disabled`, `pointerEvents`, `editable`, `scrollEnabled`)
directly on the UI thread. This avoids `useState` re-renders entirely.

`useAnimatedStyle` handles style properties. `useAnimatedProps` handles
everything else—component props that aren't styles but still need to react
to shared values.

**Incorrect (runOnJS bridges back to JS thread, causing re-render):**

```tsx
import { useState } from 'react'
import { TextInput, View } from 'react-native'
import Animated, {
  useSharedValue,
  useAnimatedReaction,
  runOnJS,
} from 'react-native-reanimated'

function SubmitForm() {
  const isSubmitting = useSharedValue(false)
  const [disabled, setDisabled] = useState(false)

  // Bad: bridges UI thread → JS thread → setState → re-render
  useAnimatedReaction(
    () => isSubmitting.get(),
    (current) => {
      runOnJS(setDisabled)(current)
    }
  )

  return (
    <View pointerEvents={disabled ? 'none' : 'auto'}>
      <TextInput editable={!disabled} />
    </View>
  )
}
```

**Correct (useAnimatedProps stays on UI thread, zero re-renders):**

```tsx
import { TextInput, View } from 'react-native'
import Animated, {
  useSharedValue,
  useAnimatedProps,
} from 'react-native-reanimated'

const AnimatedTextInput = Animated.createAnimatedComponent(TextInput)
const AnimatedView = Animated.createAnimatedComponent(View)

function SubmitForm() {
  const isSubmitting = useSharedValue(false)

  const viewProps = useAnimatedProps(() => ({
    pointerEvents: isSubmitting.get() ? 'none' as const : 'auto' as const,
  }))

  const inputProps = useAnimatedProps(() => ({
    editable: !isSubmitting.get(),
  }))

  return (
    <AnimatedView animatedProps={viewProps}>
      <AnimatedTextInput animatedProps={inputProps} />
    </AnimatedView>
  )
}
```

**Common use cases for useAnimatedProps:**

| Prop              | Component         | Example                                      |
|-------------------|-------------------|----------------------------------------------|
| `disabled`        | Button, Pressable | Disable during animation or submission       |
| `pointerEvents`   | View              | Block touches during transitions             |
| `editable`        | TextInput         | Lock input during async operations           |
| `scrollEnabled`   | ScrollView        | Disable scroll during gesture interactions   |

Reference: [Reanimated useAnimatedProps](https://docs.swmansion.com/react-native-reanimated/docs/core/useAnimatedProps)
