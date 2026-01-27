---
title: Avoid Namespace React Imports
impact: MEDIUM
impactDescription: cleaner imports, better tree-shaking
tags: bundle, imports, react, tree-shaking, code-style
---

## Avoid Namespace React Imports

React 17+ with the new JSX transform no longer requires importing React to use JSX. Use named imports directly from 'react' instead of namespace imports for cleaner code and better tree-shaking.

**Incorrect (namespace import - unnecessary):**

```tsx
import * as React from 'react'

function Button() {
  const [count, setCount] = React.useState(0)
  const ref = React.useRef<HTMLButtonElement>(null)
  
  React.useEffect(() => {
    console.log('mounted')
  }, [])
  
  return <button ref={ref}>{count}</button>
}
```

**Incorrect (default import - legacy pattern):**

```tsx
import React from 'react'

function Button() {
  const [count, setCount] = React.useState(0)
  
  return <button>{count}</button>
}
```

**Correct (named imports only):**

```tsx
import { useState, useRef, useEffect } from 'react'

function Button() {
  const [count, setCount] = useState(0)
  const ref = useRef<HTMLButtonElement>(null)
  
  useEffect(() => {
    console.log('mounted')
  }, [])
  
  return <button ref={ref}>{count}</button>
}
```

**Why avoid namespace imports:**

1. **Verbose code** - `React.useState` is longer than `useState`
2. **Worse tree-shaking** - Bundlers can better optimize named imports
3. **Unnecessary since React 17** - New JSX transform doesn't require React in scope
4. **IDE autocomplete** - Named imports provide better IntelliSense

**Exception - when you need React namespace:**

```tsx
// Only use namespace when you need the React type itself
import { useRef, type ReactNode, type ComponentProps } from 'react'

// ✅ Type imports are fine as named imports
type Props = {
  children: ReactNode
  onClick: ComponentProps<'button'>['onClick']
}
```

Reference: [Introducing the New JSX Transform](https://legacy.reactjs.org/blog/2020/09/22/introducing-the-new-jsx-transform.html)
