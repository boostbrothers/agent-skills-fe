---
title: Built-in React Hooks Correct Usage Patterns
impact: HIGH
impactDescription: prevents bugs, infinite loops, memory leaks
tags: hooks, useState, useEffect, useRef, useMemo, useCallback, patterns
---

## Built-in React Hooks Correct Usage Patterns

React hooks have specific rules and patterns that, when violated, cause bugs, infinite loops, or memory leaks. This guide covers common mistakes and correct patterns.

### useState

**Incorrect (object mutation):**

```tsx
function UserForm() {
  const [user, setUser] = useState({ name: '', email: '' })
  
  const updateName = (name: string) => {
    // ❌ Mutating existing state object
    user.name = name
    setUser(user)
  }
}
```

**Correct (immutable update):**

```tsx
function UserForm() {
  const [user, setUser] = useState({ name: '', email: '' })
  
  const updateName = (name: string) => {
    // ✅ Create new object
    setUser(prev => ({ ...prev, name }))
  }
}
```

**Incorrect (stale closure):**

```tsx
function Counter() {
  const [count, setCount] = useState(0)
  
  const incrementThreeTimes = () => {
    // ❌ All three use same stale count value
    setCount(count + 1)
    setCount(count + 1)
    setCount(count + 1)
    // Result: count increases by 1, not 3
  }
}
```

**Correct (functional update):**

```tsx
function Counter() {
  const [count, setCount] = useState(0)
  
  const incrementThreeTimes = () => {
    // ✅ Each update uses latest value
    setCount(c => c + 1)
    setCount(c => c + 1)
    setCount(c => c + 1)
    // Result: count increases by 3
  }
}
```

### useEffect

**Incorrect (missing cleanup):**

```tsx
function ChatRoom({ roomId }: { roomId: string }) {
  useEffect(() => {
    const connection = createConnection(roomId)
    connection.connect()
    // ❌ Connection never closed - memory leak
  }, [roomId])
}
```

**Correct (proper cleanup):**

```tsx
function ChatRoom({ roomId }: { roomId: string }) {
  useEffect(() => {
    const connection = createConnection(roomId)
    connection.connect()
    
    // ✅ Cleanup on unmount or roomId change
    return () => connection.disconnect()
  }, [roomId])
}
```

**Incorrect (infinite loop):**

```tsx
function DataFetcher({ url }: { url: string }) {
  const [data, setData] = useState(null)
  
  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
  }) // ❌ Missing dependency array - runs every render
}
```

**Correct (proper dependencies):**

```tsx
function DataFetcher({ url }: { url: string }) {
  const [data, setData] = useState(null)
  
  useEffect(() => {
    let cancelled = false
    
    fetch(url)
      .then(res => res.json())
      .then(data => {
        if (!cancelled) setData(data)
      })
    
    // ✅ Prevent state update after unmount
    return () => { cancelled = true }
  }, [url]) // ✅ Only re-run when url changes
}
```

**Incorrect (setting state for derived values):**

```tsx
function FilteredList({ items, filter }: Props) {
  const [filteredItems, setFilteredItems] = useState<Item[]>([])
  
  // ❌ Unnecessary effect and state
  useEffect(() => {
    setFilteredItems(items.filter(item => item.name.includes(filter)))
  }, [items, filter])
}
```

**Correct (compute during render):**

```tsx
function FilteredList({ items, filter }: Props) {
  // ✅ Derived value computed directly
  const filteredItems = useMemo(
    () => items.filter(item => item.name.includes(filter)),
    [items, filter]
  )
}
```

### useRef

**Incorrect (ref in render):**

```tsx
function Timer() {
  const countRef = useRef(0)
  
  // ❌ Reading/writing ref during render causes inconsistencies
  countRef.current += 1
  
  return <div>Render count: {countRef.current}</div>
}
```

**Correct (ref in effects/handlers):**

```tsx
function Timer() {
  const [count, setCount] = useState(0)
  const intervalRef = useRef<NodeJS.Timeout | null>(null)
  
  useEffect(() => {
    // ✅ Ref used in effect
    intervalRef.current = setInterval(() => {
      setCount(c => c + 1)
    }, 1000)
    
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current)
    }
  }, [])
  
  return <div>Count: {count}</div>
}
```

### useMemo / useCallback

**Incorrect (wrong dependency):**

```tsx
function SearchResults({ query, data }: Props) {
  const results = useMemo(() => {
    return data.filter(item => item.name.includes(query))
  }, [query]) // ❌ Missing 'data' dependency
}
```

**Correct (all dependencies):**

```tsx
function SearchResults({ query, data }: Props) {
  const results = useMemo(() => {
    return data.filter(item => item.name.includes(query))
  }, [query, data]) // ✅ All dependencies included
}
```

**Incorrect (unnecessary memoization):**

```tsx
function Greeting({ name }: { name: string }) {
  // ❌ Simple concatenation doesn't need memoization
  const greeting = useMemo(() => `Hello, ${name}!`, [name])
  
  // ❌ Inline callback doesn't need useCallback
  const handleClick = useCallback(() => {
    console.log('clicked')
  }, [])
  
  return <button onClick={handleClick}>{greeting}</button>
}
```

**Correct (memoize expensive operations):**

```tsx
function DataGrid({ rows, sortConfig }: Props) {
  // ✅ Expensive sorting operation
  const sortedRows = useMemo(() => {
    return [...rows].sort((a, b) => {
      // Complex sorting logic
    })
  }, [rows, sortConfig])
  
  // ✅ Callback passed to memoized child
  const handleRowClick = useCallback((row: Row) => {
    onRowSelect(row.id)
  }, [onRowSelect])
  
  return <MemoizedTable rows={sortedRows} onRowClick={handleRowClick} />
}
```

### useContext

**Incorrect (missing provider):**

```tsx
const ThemeContext = createContext<Theme | null>(null)

function Button() {
  // ❌ Could be null if no provider exists
  const theme = useContext(ThemeContext)
  return <button className={theme.primary}>Click</button>
}
```

**Correct (null check or default value):**

```tsx
const ThemeContext = createContext<Theme>({
  primary: 'blue',
  secondary: 'gray'
})

// Or with null check
function useTheme() {
  const theme = useContext(ThemeContext)
  if (!theme) {
    throw new Error('useTheme must be used within ThemeProvider')
  }
  return theme
}
```

### useReducer

**Incorrect (mutating state in reducer):**

```tsx
function reducer(state: State, action: Action) {
  switch (action.type) {
    case 'add':
      // ❌ Mutating existing array
      state.items.push(action.item)
      return state
  }
}
```

**Correct (immutable reducer):**

```tsx
function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'add':
      // ✅ Return new state object
      return {
        ...state,
        items: [...state.items, action.item]
      }
    default:
      return state
  }
}
```

### Rules of Hooks Summary

1. **Only call at top level** - Never inside loops, conditions, or nested functions
2. **Only call in React functions** - Components or custom hooks
3. **Include all dependencies** - ESLint plugin helps catch missing deps
4. **Don't mutate** - State and refs should be updated immutably
5. **Cleanup effects** - Return cleanup function for subscriptions/timers
6. **Memoize wisely** - Only for expensive computations or stable references

Reference: [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks)
