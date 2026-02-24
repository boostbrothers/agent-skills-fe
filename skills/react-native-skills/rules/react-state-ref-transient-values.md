---
title: Use useRef for Transient Values That Don't Affect Rendering
impact: MEDIUM
impactDescription: eliminates re-renders from non-visual state updates
tags: react-state, useRef, transient, performance, re-render
---

## Use useRef for Transient Values That Don't Affect Rendering

Use `useRef` for values that don't need to trigger re-renders: timer IDs,
previous values, measurement caches, `isMounted` flags, and intermediate
computation results. Storing these in `useState` causes unnecessary re-renders.

**Incorrect (useState for timer ID — re-renders on every debounce reset):**

```tsx
import { useState, useEffect } from 'react'

function SearchInput() {
  const [query, setQuery] = useState('')
  const [timerId, setTimerId] = useState<ReturnType<typeof setTimeout> | null>(
    null
  )

  const handleChange = (text: string) => {
    setQuery(text)
    if (timerId) clearTimeout(timerId)
    // Bad: setTimerId triggers a re-render every keystroke (on top of setQuery)
    setTimerId(setTimeout(() => search(text), 300))
  }

  return <TextInput value={query} onChangeText={handleChange} />
}
```

**Correct (useRef for timer ID — no extra re-renders):**

```tsx
import { useState, useRef, useEffect } from 'react'

function SearchInput() {
  const [query, setQuery] = useState('')
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const handleChange = (text: string) => {
    setQuery(text)
    if (timerRef.current) clearTimeout(timerRef.current)
    // Good: updating a ref doesn't trigger re-render
    timerRef.current = setTimeout(() => search(text), 300)
  }

  useEffect(() => {
    return () => {
      if (timerRef.current) clearTimeout(timerRef.current)
    }
  }, [])

  return <TextInput value={query} onChangeText={handleChange} />
}
```

**Other common useRef use cases:**

```tsx
// Previous value tracking
function usePrevious<T>(value: T): T | undefined {
  const ref = useRef<T | undefined>(undefined)
  useEffect(() => {
    ref.current = value
  })
  return ref.current
}

// Layout measurement cache
function MeasuredComponent() {
  const layoutRef = useRef<{ width: number; height: number } | null>(null)

  const onLayout = (e: LayoutChangeEvent) => {
    // Good: caching measurements doesn't need a re-render
    layoutRef.current = {
      width: e.nativeEvent.layout.width,
      height: e.nativeEvent.layout.height,
    }
  }

  return <View onLayout={onLayout} />
}

// Gesture state tracking (between handlers)
function DraggableItem() {
  const startPosition = useRef({ x: 0, y: 0 })

  const panGesture = Gesture.Pan()
    .onStart((e) => {
      startPosition.current = { x: e.absoluteX, y: e.absoluteY }
    })
    .onEnd((e) => {
      const dx = e.absoluteX - startPosition.current.x
      // use dx for logic...
    })

  // ...
}
```

**Rule of thumb:** If updating a value should NOT cause the UI to change,
use `useRef`. If it should, use `useState`.

Reference: [React useRef](https://react.dev/reference/react/useRef)
