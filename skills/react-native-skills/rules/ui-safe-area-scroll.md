---
title: Use contentInsetAdjustmentBehavior for Safe Areas
impact: MEDIUM
impactDescription: native safe area handling, no layout shifts
tags: safe-area, scrollview, layout
---

## Use contentInsetAdjustmentBehavior for Safe Areas

**⚠️ Important: iOS Only** - `contentInsetAdjustmentBehavior` is an iOS-only prop and will not work on Android. For cross-platform apps, use `react-native-safe-area-context` instead.

For iOS-only apps or iOS-specific optimizations, `contentInsetAdjustmentBehavior="automatic"` on the root ScrollView provides native safe area handling with proper scroll behavior.

**Incorrect (SafeAreaView wrapper):**

```tsx
import { SafeAreaView, ScrollView, View, Text } from 'react-native'

function MyScreen() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <ScrollView>
        <View>
          <Text>Content</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  )
}
```

**Incorrect (manual safe area padding):**

```tsx
import { ScrollView, View, Text } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

function MyScreen() {
  const insets = useSafeAreaInsets()

  return (
    <ScrollView contentContainerStyle={{ paddingTop: insets.top }}>
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

**Correct for iOS-only apps (native content inset adjustment):**

```tsx
import { ScrollView, View, Text, Platform } from 'react-native'

function MyScreen() {
  return (
    <ScrollView 
      contentInsetAdjustmentBehavior={Platform.OS === 'ios' ? 'automatic' : undefined}
    >
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

**Best practice for cross-platform apps - Option 1 (SafeAreaView wrapper):**

For most cases, wrapping your ScrollView with SafeAreaView from react-native-safe-area-context is the simplest approach.

```tsx
import { ScrollView, View, Text } from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'

function MyScreen() {
  return (
    <SafeAreaView style={{ flex: 1 }} edges={['top']}>
      <ScrollView>
        <View>
          <Text>Content</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  )
}
```

**Best practice for cross-platform apps - Option 2 (useSafeAreaInsets for fine control):**

When you need more control over individual edges, use useSafeAreaInsets hook.

```tsx
import { ScrollView, View, Text } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

function MyScreen() {
  const insets = useSafeAreaInsets()

  return (
    <ScrollView 
      contentContainerStyle={{ 
        paddingTop: insets.top,
        paddingBottom: insets.bottom 
      }}
    >
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

The iOS-only `contentInsetAdjustmentBehavior` handles dynamic safe areas (keyboard, toolbars) and allows content to scroll behind the status bar naturally, but is not suitable for cross-platform development. Use `react-native-safe-area-context` for apps that need to work on both iOS and Android.
