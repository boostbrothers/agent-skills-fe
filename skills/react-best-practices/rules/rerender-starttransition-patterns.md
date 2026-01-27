---
title: startTransition Correct Usage Patterns
impact: HIGH
impactDescription: maintains UI responsiveness, prevents blocking
tags: rerender, transitions, startTransition, useTransition, performance
---

## startTransition Correct Usage Patterns

`startTransition` marks state updates as non-urgent, allowing React to keep the UI responsive during heavy updates. Understanding when and how to use it is crucial for optimal performance.

**Incorrect (using startTransition for urgent updates):**

```tsx
import { startTransition } from 'react'

function SearchInput() {
  const [query, setQuery] = useState('')
  
  return (
    <input
      value={query}
      onChange={(e) => {
        // ❌ Input value should update immediately
        startTransition(() => {
          setQuery(e.target.value)
        })
      }}
    />
  )
}
```

**Correct (separate urgent and non-urgent updates):**

```tsx
import { useState, startTransition } from 'react'

function SearchInput() {
  const [query, setQuery] = useState('')        // Urgent: input display
  const [results, setResults] = useState([])    // Non-urgent: search results
  
  return (
    <>
      <input
        value={query}
        onChange={(e) => {
          // ✅ Input updates immediately
          setQuery(e.target.value)
          
          // ✅ Heavy search operation is non-urgent
          startTransition(() => {
            setResults(searchItems(e.target.value))
          })
        }}
      />
      <SearchResults results={results} />
    </>
  )
}
```

**Incorrect (async function inside startTransition):**

```tsx
import { startTransition } from 'react'

function DataLoader() {
  const [data, setData] = useState(null)
  
  const loadData = async () => {
    startTransition(async () => {
      // ❌ Async functions don't work - state update happens after transition ends
      const result = await fetchData()
      setData(result)
    })
  }
}
```

**Correct (state update before await):**

```tsx
import { startTransition } from 'react'

function DataLoader() {
  const [data, setData] = useState(null)
  const [isPending, setIsPending] = useState(false)
  
  const loadData = async () => {
    setIsPending(true)
    const result = await fetchData()
    
    // ✅ startTransition wraps the synchronous state update
    startTransition(() => {
      setData(result)
      setIsPending(false)
    })
  }
}
```

**Correct (useTransition for pending state):**

```tsx
import { useState, useTransition } from 'react'

function TabContainer() {
  const [tab, setTab] = useState('home')
  const [isPending, startTransition] = useTransition()
  
  return (
    <div>
      <TabBar
        currentTab={tab}
        onTabChange={(newTab) => {
          // ✅ useTransition provides isPending state
          startTransition(() => {
            setTab(newTab)
          })
        }}
      />
      {isPending && <Spinner />}
      <TabContent tab={tab} />
    </div>
  )
}
```

**Incorrect (wrapping non-state-update code):**

```tsx
function Form() {
  const handleSubmit = () => {
    startTransition(() => {
      // ❌ No state update inside - transition does nothing
      console.log('Submitting...')
      fetch('/api/submit', { method: 'POST' })
    })
  }
}
```

**Correct (only wrap state updates):**

```tsx
function Form() {
  const [status, setStatus] = useState('idle')
  
  const handleSubmit = async () => {
    console.log('Submitting...')
    await fetch('/api/submit', { method: 'POST' })
    
    // ✅ Only the state update is wrapped
    startTransition(() => {
      setStatus('submitted')
    })
  }
}
```

**Incorrect (startTransition for initial render):**

```tsx
function App() {
  const [items, setItems] = useState([])
  
  useEffect(() => {
    // ❌ startTransition doesn't help during initial render
    startTransition(() => {
      setItems(generateLargeList())
    })
  }, [])
}
```

**Correct (use Suspense for initial data):**

```tsx
import { Suspense, use } from 'react'

function App() {
  return (
    // ✅ Suspense handles initial loading
    <Suspense fallback={<Loading />}>
      <ItemList />
    </Suspense>
  )
}

function ItemList() {
  const items = use(fetchItems())
  return <List items={items} />
}
```

**Advanced: combining with useDeferredValue:**

```tsx
import { useState, useDeferredValue, memo } from 'react'

function SearchPage() {
  const [query, setQuery] = useState('')
  // ✅ deferredQuery lags behind during rapid updates
  const deferredQuery = useDeferredValue(query)
  const isStale = query !== deferredQuery
  
  return (
    <div>
      <input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      <div style={{ opacity: isStale ? 0.5 : 1 }}>
        <SearchResults query={deferredQuery} />
      </div>
    </div>
  )
}

// ✅ Memoize to skip re-renders when deferredQuery hasn't changed
const SearchResults = memo(function SearchResults({ query }: { query: string }) {
  const results = searchDatabase(query) // Expensive operation
  return <ResultsList results={results} />
})
```

**Key principles:**

1. **Urgent vs non-urgent** - User input is urgent, derived computations are not
2. **Synchronous only** - startTransition callback must be synchronous
3. **State updates only** - Only wrap setState calls, not side effects
4. **Use with Suspense** - Transitions work best with Suspense boundaries
5. **isPending for feedback** - Use useTransition when you need loading indicators

Reference: [React startTransition](https://react.dev/reference/react/startTransition)
