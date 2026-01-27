---
title: Provide Default Values for Optional Props
impact: MEDIUM
impactDescription: prevents undefined errors, stable references
tags: rerender, props, defaults, typescript, stability
---

## Provide Default Values for Optional Props

Always provide default values for optional props using destructuring defaults. This prevents undefined checks throughout components and ensures stable references for dependency arrays.

**Incorrect (no defaults - requires defensive checks):**

```tsx
interface ButtonProps {
  onClick?: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
  className?: string
}

function Button({ onClick, disabled, variant, className }: ButtonProps) {
  // ❌ Need to check for undefined everywhere
  const handleClick = () => {
    if (onClick) {
      onClick()
    }
  }
  
  // ❌ Conditional class logic is messy
  const classes = `btn ${variant ? `btn-${variant}` : 'btn-primary'} ${className || ''}`
  
  return (
    <button 
      onClick={handleClick} 
      disabled={disabled ?? false}
      className={classes}
    >
      Click me
    </button>
  )
}
```

**Incorrect (defaults in function body - unstable references):**

```tsx
function UserList({ users, onSelect, renderItem }: UserListProps) {
  // ❌ Creates new function on every render
  const handleSelect = onSelect || (() => {})
  
  // ❌ Creates new function on every render - breaks memoization
  const defaultRender = renderItem || ((user) => <span>{user.name}</span>)
  
  useEffect(() => {
    // This effect runs on every render because handleSelect changes
  }, [handleSelect])
}
```

**Correct (defaults in destructuring):**

```tsx
interface ButtonProps {
  onClick?: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
  className?: string
}

// ✅ Noop function defined outside component for stable reference
const noop = () => {}

function Button({ 
  onClick = noop,
  disabled = false, 
  variant = 'primary',
  className = ''
}: ButtonProps) {
  // ✅ No undefined checks needed
  const classes = `btn btn-${variant} ${className}`.trim()
  
  return (
    <button onClick={onClick} disabled={disabled} className={classes}>
      Click me
    </button>
  )
}
```

**Correct (with stable default functions):**

```tsx
interface UserListProps {
  users: User[]
  onSelect?: (user: User) => void
  renderItem?: (user: User) => ReactNode
  filterFn?: (user: User) => boolean
}

// ✅ Define defaults outside component for stable references
const defaultOnSelect = () => {}
const defaultRenderItem = (user: User) => <span>{user.name}</span>
const defaultFilter = () => true

function UserList({ 
  users,
  onSelect = defaultOnSelect,
  renderItem = defaultRenderItem,
  filterFn = defaultFilter
}: UserListProps) {
  const filteredUsers = useMemo(
    () => users.filter(filterFn),
    [users, filterFn] // ✅ filterFn is stable
  )
  
  useEffect(() => {
    // ✅ Won't re-run unnecessarily
  }, [onSelect])
  
  return (
    <ul>
      {filteredUsers.map(user => (
        <li key={user.id} onClick={() => onSelect(user)}>
          {renderItem(user)}
        </li>
      ))}
    </ul>
  )
}
```

**Correct (with complex default objects):**

```tsx
interface TableProps {
  data: Row[]
  columns: Column[]
  pagination?: {
    pageSize: number
    currentPage: number
  }
  sorting?: {
    field: string
    direction: 'asc' | 'desc'
  }
}

// ✅ Default objects defined outside for stability
const defaultPagination = { pageSize: 10, currentPage: 1 }
const defaultSorting = { field: 'id', direction: 'asc' as const }

function Table({
  data,
  columns,
  pagination = defaultPagination,
  sorting = defaultSorting
}: TableProps) {
  // pagination and sorting are always defined with stable references
}
```

**Key principles:**

1. **Define defaults outside** - Functions and objects as defaults should be defined outside the component
2. **Use `noop` for callbacks** - A shared empty function prevents unnecessary re-renders
3. **Provide sensible defaults** - Choose defaults that make the component work without configuration
4. **Stable references** - Default values in dependency arrays should be referentially stable

Reference: [React Docs - Default Prop Values](https://react.dev/learn/passing-props-to-a-component#specifying-a-default-value-for-a-prop)
