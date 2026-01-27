---
title: Use Optimized Image Components
impact: HIGH
impactDescription: memory efficiency, caching, blurhash placeholders, progressive loading
tags: images, performance, expo-image, turbo-image, ui
---

## Use Optimized Image Components

Use optimized image components like `react-native-turbo-image` or `expo-image` instead of React Native's `Image`. They provide memory-efficient caching, blurhash placeholders, progressive loading, and better performance for lists.

**Incorrect (React Native Image):**

```tsx
import { Image } from 'react-native'

function Avatar({ url }: { url: string }) {
  return <Image source={{ uri: url }} style={styles.avatar} />
}
```

**Correct - Option 1 (react-native-turbo-image):**

`react-native-turbo-image` provides high-performance image loading with advanced caching, progressive loading, and memory management. Recommended for apps requiring optimal performance.

```tsx
import { TurboImage } from 'react-native-turbo-image'

function Avatar({ url }: { url: string }) {
  return (
    <TurboImage 
      source={{ uri: url }} 
      style={styles.avatar}
      cachePolicy="urlCache"
      resizeMode="cover"
    />
  )
}
```

**Correct - Option 2 (expo-image):**

`expo-image` is Expo's optimized image component with excellent caching and placeholder support.

```tsx
import { Image } from 'expo-image'

function Avatar({ url }: { url: string }) {
  return <Image source={{ uri: url }} style={styles.avatar} />
}
```

**With react-native-turbo-image - blurhash placeholder:**

```tsx
<TurboImage
  source={{ uri: url }}
  style={styles.image}
  placeholder={{ blurhash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.' }}
  cachePolicy="urlCache"
  resizeMode="cover"
  showPlaceholderOnFailure
/>
```

**With react-native-turbo-image - advanced features:**

```tsx
<TurboImage
  source={{ uri: url }}
  style={styles.hero}
  cachePolicy="dataCache"
  indicator="progressBar"
  fadeDuration={300}
  resize={600}
  rounded
/>
```

**With expo-image - blurhash placeholder:**

```tsx
<Image
  source={{ uri: url }}
  placeholder={{ blurhash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.' }}
  contentFit="cover"
  transition={200}
  style={styles.image}
/>
```

**With expo-image - priority and caching:**

```tsx
<Image
  source={{ uri: url }}
  priority="high"
  cachePolicy="memory-disk"
  style={styles.hero}
/>
```

**Key props for react-native-turbo-image:**

- `placeholder` — Blurhash, thumbhash, or thumbnail while loading
- `cachePolicy` — `urlCache`, `dataCache`, `both`
- `indicator` — `progressBar`, `placeholder`
- `fadeDuration` — Fade-in duration (ms)
- `resize` — Resize image to specific size
- `rounded` — Rounded corners with native performance
- `showPlaceholderOnFailure` — Show placeholder on error

**Key props for expo-image:**

- `placeholder` — Blurhash or thumbnail while loading
- `contentFit` — `cover`, `contain`, `fill`, `scale-down`
- `transition` — Fade-in duration (ms)
- `priority` — `low`, `normal`, `high`
- `cachePolicy` — `memory`, `disk`, `memory-disk`, `none`
- `recyclingKey` — Unique key for list recycling

**Which to choose:**

- Use `react-native-turbo-image` for maximum performance and advanced features
- Use `expo-image` for Expo projects or if you need web support
- For cross-platform (web + native), use `SolitoImage` from `solito/image` which uses `expo-image` under the hood

Reference: 
- [react-native-turbo-image](https://github.com/duguyihou/react-native-turbo-image)
- [expo-image](https://docs.expo.dev/versions/latest/sdk/image/)
