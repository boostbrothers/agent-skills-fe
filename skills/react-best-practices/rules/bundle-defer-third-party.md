---
title: Defer Non-Critical Third-Party Libraries
impact: MEDIUM
impactDescription: loads after hydration
tags: bundle, third-party, analytics, defer
---

## Defer Non-Critical Third-Party Libraries

Analytics, logging, and error tracking don't block user interaction. Load them after hydration.

**Incorrect (blocks initial bundle):**

```tsx
import { Analytics } from '@vercel/analytics/react'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  )
}
```

**Correct (Next.js - loads after hydration):**

```tsx
import dynamic from 'next/dynamic'

const Analytics = dynamic(
  () => import('@vercel/analytics/react').then(m => m.Analytics),
  { ssr: false }
)

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  )
}
```

**Correct (React / Vite / CRA - loads after mount):**

```tsx
import { lazy, Suspense } from 'react'

const Analytics = lazy(
  () => import('@vercel/analytics/react').then(m => ({ default: m.Analytics }))
)

export default function App({ children }) {
  return (
    <div>
      {children}
      <Suspense fallback={null}>
        <Analytics />
      </Suspense>
    </div>
  )
}
```
