---
title: React DOM APIs Correct Usage Patterns
impact: HIGH
impactDescription: proper hydration, portal usage, performance
tags: rendering, react-dom, createPortal, createRoot, flushSync, hydration
---

## React DOM APIs Correct Usage Patterns

React DOM provides browser-specific APIs for rendering React components. Using them correctly ensures proper hydration, performance, and expected behavior.

### createRoot / hydrateRoot

**Incorrect (calling createRoot multiple times):**

```tsx
// ❌ Creates new root on every call
function renderApp() {
  const root = createRoot(document.getElementById('root')!)
  root.render(<App />)
}

button.addEventListener('click', renderApp)
```

**Correct (create root once, render multiple times):**

```tsx
import { createRoot } from 'react-dom/client'

// ✅ Create root once
const root = createRoot(document.getElementById('root')!)

function renderApp(state: AppState) {
  root.render(<App state={state} />)
}

// Re-render with new props
button.addEventListener('click', () => renderApp(newState))
```

**Incorrect (using createRoot for SSR):**

```tsx
// ❌ createRoot doesn't preserve server HTML
const root = createRoot(document.getElementById('root')!)
root.render(<App />)
// Server-rendered HTML is discarded, causes flicker
```

**Correct (hydrateRoot for SSR):**

```tsx
import { hydrateRoot } from 'react-dom/client'

// ✅ Preserves server HTML, attaches event handlers
hydrateRoot(document.getElementById('root')!, <App />)
```

### createPortal

**Incorrect (portal without proper event handling):**

```tsx
function Modal({ children, onClose }: ModalProps) {
  // ❌ Click outside doesn't close modal
  return createPortal(
    <div className="modal">
      {children}
    </div>,
    document.body
  )
}
```

**Correct (portal with backdrop and event handling):**

```tsx
import { createPortal } from 'react-dom'

function Modal({ children, onClose }: ModalProps) {
  return createPortal(
    // ✅ Backdrop captures outside clicks
    <div className="modal-backdrop" onClick={onClose}>
      <div 
        className="modal-content" 
        onClick={(e) => e.stopPropagation()} // Prevent closing when clicking inside
      >
        {children}
      </div>
    </div>,
    document.body
  )
}
```

**Incorrect (portal target doesn't exist):**

```tsx
function Tooltip({ children }: TooltipProps) {
  // ❌ Element might not exist yet
  return createPortal(
    <div className="tooltip">{children}</div>,
    document.getElementById('tooltip-root')!
  )
}
```

**Correct (ensure portal target exists):**

```tsx
import { createPortal } from 'react-dom'
import { useState, useEffect } from 'react'

function Tooltip({ children }: TooltipProps) {
  const [container, setContainer] = useState<HTMLElement | null>(null)
  
  useEffect(() => {
    // ✅ Create container if it doesn't exist
    let el = document.getElementById('tooltip-root')
    if (!el) {
      el = document.createElement('div')
      el.id = 'tooltip-root'
      document.body.appendChild(el)
    }
    setContainer(el)
  }, [])
  
  if (!container) return null
  
  return createPortal(
    <div className="tooltip">{children}</div>,
    container
  )
}
```

### flushSync

**Incorrect (overusing flushSync):**

```tsx
import { flushSync } from 'react-dom'

function Form() {
  const [value, setValue] = useState('')
  
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    // ❌ Unnecessary - normal updates work fine here
    flushSync(() => {
      setValue(e.target.value)
    })
  }
}
```

**Correct (flushSync for DOM measurements):**

```tsx
import { flushSync } from 'react-dom'
import { useState, useRef } from 'react'

function ExpandableList() {
  const [items, setItems] = useState<string[]>([])
  const listRef = useRef<HTMLUListElement>(null)
  
  const addItem = (item: string) => {
    // ✅ Need DOM updated before scrolling
    flushSync(() => {
      setItems(prev => [...prev, item])
    })
    
    // Now DOM is updated, can safely scroll
    listRef.current?.lastElementChild?.scrollIntoView()
  }
  
  return <ul ref={listRef}>{items.map(item => <li key={item}>{item}</li>)}</ul>
}
```

**Correct (flushSync for third-party integration):**

```tsx
import { flushSync } from 'react-dom'

function Editor() {
  const [content, setContent] = useState('')
  const editorRef = useRef<ExternalEditor>(null)
  
  const syncWithExternalEditor = () => {
    // ✅ External library needs DOM to be updated immediately
    flushSync(() => {
      setContent(editorRef.current?.getValue() ?? '')
    })
    
    // Now React DOM matches external editor state
    externalLibrary.notifyUpdate()
  }
}
```

### preload / prefetchDNS / preconnect

**Correct (resource hints for performance):**

```tsx
import { preload, prefetchDNS, preconnect } from 'react-dom'

function App() {
  // ✅ Preconnect to API origin early
  preconnect('https://api.example.com')
  
  // ✅ Prefetch DNS for third-party resources
  prefetchDNS('https://analytics.example.com')
  
  // ✅ Preload critical resources
  preload('/fonts/inter.woff2', { as: 'font', type: 'font/woff2' })
  preload('/hero-image.webp', { as: 'image' })
  
  return <MainContent />
}
```

### Hydration Mismatch Prevention

**Incorrect (client-only values during SSR):**

```tsx
function Greeting() {
  // ❌ Different value on server vs client
  const time = new Date().toLocaleTimeString()
  return <p>Current time: {time}</p>
}
```

**Correct (useEffect for client-only values):**

```tsx
import { useState, useEffect } from 'react'

function Greeting() {
  const [time, setTime] = useState<string | null>(null)
  
  useEffect(() => {
    // ✅ Only runs on client after hydration
    setTime(new Date().toLocaleTimeString())
    const interval = setInterval(() => {
      setTime(new Date().toLocaleTimeString())
    }, 1000)
    return () => clearInterval(interval)
  }, [])
  
  // ✅ Server and initial client render match
  return <p>Current time: {time ?? 'Loading...'}</p>
}
```

**Correct (suppressHydrationWarning for intentional mismatches):**

```tsx
function Timestamp() {
  return (
    // ✅ Explicitly suppress warning for known mismatch
    <time suppressHydrationWarning>
      {new Date().toISOString()}
    </time>
  )
}
```

**Key principles:**

1. **createRoot once** - Create root at app initialization, not per-render
2. **hydrateRoot for SSR** - Always use hydrateRoot when server-rendering
3. **flushSync sparingly** - Only for DOM measurements or third-party sync
4. **Portal cleanup** - Ensure portal targets exist before rendering
5. **Hydration match** - Server and client initial render must produce same HTML

Reference: [React DOM APIs](https://react.dev/reference/react-dom)
