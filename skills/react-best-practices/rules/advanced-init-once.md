---
title: Initialize App Once, Not Per Mount
impact: LOW-MEDIUM
impactDescription: avoids duplicate init in development
tags: initialization, useEffect, app-startup, side-effects
---

## Initialize App Once, Not Per Mount

Do not put app-wide initialization that must run once per app load inside `useEffect([])` of a component. Components can remount and effects will re-run. Use a module-level guard or top-level init in the entry module instead.

**Incorrect (runs twice in dev, re-runs on remount):**

```tsx
function Comp() {
  useEffect(() => {
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

**Correct (once per app load - preferred for app-wide initialization):**

```tsx
let didInit = false

function Comp() {
  useEffect(() => {
    if (didInit) return
    didInit = true
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

Use module-level `let` when initialization must run exactly once for the entire app, regardless of how many times or where the component is used.

**Alternative (once per component instance - use when initialization is component-specific):**

```tsx
function Comp() {
  const didInit = useRef(false)
  
  useEffect(() => {
    if (didInit.current) return
    didInit.current = true
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

Use `useRef` when initialization should run once per component instance. If `Comp` is rendered multiple times, each instance will run initialization once. This is suitable for component-specific setup, not app-wide initialization.

**Best Practice:**

- **App-wide initialization** (analytics, auth, storage): Use module-level `let`
- **Component-specific initialization** (local subscriptions, timers): Use `useRef`

Reference: [Initializing the application](https://react.dev/learn/you-might-not-need-an-effect#initializing-the-application)
