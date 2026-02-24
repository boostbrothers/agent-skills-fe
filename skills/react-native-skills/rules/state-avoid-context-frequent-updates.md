---
title: Never Use React Context for Frequently Changing State
impact: HIGH
impactDescription: prevents cascading re-renders across consumer tree
tags: state, context, jotai, zustand, re-render, architecture
---

## Never Use React Context for Frequently Changing State

React Context re-renders every consumer when the provider value changes—there
is no built-in selector mechanism. For state that changes often (input text,
toggles, counters, filters), use Jotai atoms or Zustand stores instead.

Context is appropriate for values that change rarely: theme, locale, auth
status, feature flags.

**Incorrect (Context with frequent updates re-renders all consumers):**

```tsx
import { createContext, useContext, useState, type ReactNode } from 'react'

interface SearchContextType {
  query: string
  setQuery: (q: string) => void
  filters: Filter[]
  setFilters: (f: Filter[]) => void
}

const SearchContext = createContext<SearchContextType | null>(null)

function SearchProvider({ children }: { children: ReactNode }) {
  const [query, setQuery] = useState('')
  const [filters, setFilters] = useState<Filter[]>([])

  return (
    <SearchContext.Provider value={{ query, setQuery, filters, setFilters }}>
      {children}
    </SearchContext.Provider>
  )
}

// Bad: FilterPanel re-renders on every keystroke in SearchInput
function FilterPanel() {
  const { filters, setFilters } = useContext(SearchContext)!
  return <FilterList filters={filters} onChange={setFilters} />
}

function SearchInput() {
  const { query, setQuery } = useContext(SearchContext)!
  return <TextInput value={query} onChangeText={setQuery} />
}
```

**Correct (Jotai atoms — each component subscribes only to what it needs):**

```tsx
import { atom } from 'jotai'
import { useAtom, useAtomValue } from 'jotai'

const queryAtom = atom('')
const filtersAtom = atom<Filter[]>([])

// Good: FilterPanel only re-renders when filters change
function FilterPanel() {
  const [filters, setFilters] = useAtom(filtersAtom)
  return <FilterList filters={filters} onChange={setFilters} />
}

// Good: SearchInput only re-renders when query changes
function SearchInput() {
  const [query, setQuery] = useAtom(queryAtom)
  return <TextInput value={query} onChangeText={setQuery} />
}
```

**Correct (Zustand store with selectors):**

```tsx
import { create } from 'zustand'

interface SearchStore {
  query: string
  filters: Filter[]
  setQuery: (q: string) => void
  setFilters: (f: Filter[]) => void
}

const useSearchStore = create<SearchStore>((set) => ({
  query: '',
  filters: [],
  setQuery: (query) => set({ query }),
  setFilters: (filters) => set({ filters }),
}))

// Good: only re-renders when filters change
function FilterPanel() {
  const filters = useSearchStore((s) => s.filters)
  const setFilters = useSearchStore((s) => s.setFilters)
  return <FilterList filters={filters} onChange={setFilters} />
}
```

**When Context is appropriate:**

```tsx
// Good: theme changes rarely (user toggle, system event)
const ThemeContext = createContext<Theme>(defaultTheme)

// Good: auth changes rarely (login, logout)
const AuthContext = createContext<AuthState | null>(null)

// Good: locale changes rarely (settings change)
const LocaleContext = createContext<string>('en')
```

Reference: [Passing Data Deeply with Context](https://react.dev/learn/passing-data-deeply-with-context)
