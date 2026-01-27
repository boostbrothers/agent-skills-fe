---
title: Use the React use() API for Data and Context
impact: HIGH
impactDescription: cleaner async patterns, Suspense integration
tags: async, use, suspense, context, data-fetching, react-19
---

## Use the React use() API for Data and Context

React 19's `use` API enables reading Promises and Context with Suspense integration. Unlike hooks, `use` can be called inside conditionals and loops, providing more flexible data access patterns.

**Incorrect (manual promise handling):**

```tsx
function Message({ messagePromise }: { messagePromise: Promise<string> }) {
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<Error | null>(null)
  const [loading, setLoading] = useState(true)
  
  useEffect(() => {
    messagePromise
      .then(setMessage)
      .catch(setError)
      .finally(() => setLoading(false))
  }, [messagePromise])
  
  if (loading) return <p>Loading...</p>
  if (error) return <p>Error: {error.message}</p>
  return <p>{message}</p>
}
```

**Correct (use API with Suspense):**

```tsx
import { use, Suspense } from 'react'

function Message({ messagePromise }: { messagePromise: Promise<string> }) {
  // ✅ use() suspends until promise resolves
  const message = use(messagePromise)
  return <p>{message}</p>
}

// Parent handles loading state
function App() {
  const messagePromise = fetchMessage()
  return (
    <Suspense fallback={<p>Loading...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  )
}
```

**Incorrect (useContext can't be conditional):**

```tsx
function HorizontalRule({ show }: { show: boolean }) {
  // ❌ useContext must be called unconditionally
  const theme = useContext(ThemeContext)
  
  if (!show) return null
  return <hr className={theme} />
}
```

**Correct (use can be conditional):**

```tsx
import { use } from 'react'

function HorizontalRule({ show }: { show: boolean }) {
  if (!show) return null
  
  // ✅ use() can be called conditionally
  const theme = use(ThemeContext)
  return <hr className={theme} />
}
```

**Server to Client streaming pattern:**

```tsx
// Server Component
import { Suspense } from 'react'
import { Message } from './message'

export default function App() {
  // ✅ Create promise in server component
  const messagePromise = fetchMessage()
  
  return (
    <Suspense fallback={<p>Waiting for message...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  )
}

// Client Component (message.tsx)
'use client'
import { use } from 'react'

export function Message({ messagePromise }: { messagePromise: Promise<string> }) {
  // ✅ Promise streams from server, resolved on client
  const content = use(messagePromise)
  return <p>Here is the message: {content}</p>
}
```

**Error handling with Error Boundary:**

```tsx
import { use, Suspense } from 'react'
import { ErrorBoundary } from 'react-error-boundary'

function MessageContainer({ messagePromise }: { messagePromise: Promise<string> }) {
  return (
    <ErrorBoundary fallback={<p>⚠️ Something went wrong</p>}>
      <Suspense fallback={<p>⌛ Loading...</p>}>
        <Message messagePromise={messagePromise} />
      </Suspense>
    </ErrorBoundary>
  )
}

function Message({ messagePromise }: { messagePromise: Promise<string> }) {
  const content = use(messagePromise)
  return <p>{content}</p>
}
```

**Error handling with Promise.catch:**

```tsx
function App() {
  const messagePromise = fetchMessage().catch(() => {
    return 'No message found.'
  })
  
  return (
    <Suspense fallback={<p>Loading...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  )
}
```

**Incorrect (creating promise in client component):**

```tsx
'use client'

function MessageContainer() {
  // ❌ Promise created on every render
  const messagePromise = fetchMessage()
  
  return (
    <Suspense fallback={<p>Loading...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  )
}
```

**Correct (stable promise reference):**

```tsx
'use client'
import { useMemo } from 'react'

function MessageContainer({ userId }: { userId: string }) {
  // ✅ Promise is stable across re-renders
  const messagePromise = useMemo(() => fetchMessage(userId), [userId])
  
  return (
    <Suspense fallback={<p>Loading...</p>}>
      <Message messagePromise={messagePromise} />
    </Suspense>
  )
}
```

**Key points:**

1. **use() suspends** - Component suspends until Promise resolves
2. **Conditional calls OK** - Unlike hooks, can be called in if/for blocks
3. **Create promises on server** - Pass stable promises from server to client
4. **Error Boundary for errors** - use() cannot be in try-catch blocks
5. **Serializable values only** - Promise resolved values must be serializable

Reference: [React use() API](https://react.dev/reference/react/use)
