---
title: Use splitAtom for Independent List Item Updates
impact: HIGH
impactDescription: prevents sibling re-renders on single item changes
tags: state, jotai, splitAtom, lists, re-render, performance
---

## Use splitAtom for Independent List Item Updates

Use `splitAtom` to create independent writable atoms for each item in a list.
When one item changes, only that item's component re-renders—siblings stay
untouched.

Unlike `selectAtom` (read-only derived atom for extracting a slice),
`splitAtom` gives each item a `PrimitiveAtom` that supports both read and
write independently.

**Incorrect (useAtom on whole list — all items re-render on any change):**

```tsx
import { atom, useAtom } from 'jotai'

interface Todo {
  id: string
  text: string
  done: boolean
}

const todosAtom = atom<Todo[]>([])

function TodoList() {
  const [todos, setTodos] = useAtom(todosAtom)

  const toggle = (id: string) => {
    // Bad: creates a new array → parent re-renders → all items re-render
    setTodos((prev) =>
      prev.map((t) => (t.id === id ? { ...t, done: !t.done } : t))
    )
  }

  return (
    <FlatList
      data={todos}
      renderItem={({ item }) => (
        <TodoItem todo={item} onToggle={() => toggle(item.id)} />
      )}
    />
  )
}
```

**Correct (splitAtom — each item has its own writable atom):**

```tsx
import { atom, useAtom, useAtomValue } from 'jotai'
import { splitAtom } from 'jotai/utils'
import type { PrimitiveAtom } from 'jotai'

interface Todo {
  id: string
  text: string
  done: boolean
}

const todosAtom = atom<Todo[]>([])
const todoAtomsAtom = splitAtom(todosAtom)

function TodoList() {
  const todoAtoms = useAtomValue(todoAtomsAtom)

  return (
    <FlatList
      data={todoAtoms}
      renderItem={({ item }) => <TodoItem todoAtom={item} />}
      keyExtractor={(item) => `${item}`}
    />
  )
}

// Good: only this component re-renders when its todo changes
function TodoItem({ todoAtom }: { todoAtom: PrimitiveAtom<Todo> }) {
  const [todo, setTodo] = useAtom(todoAtom)

  const toggle = () => {
    setTodo((prev) => ({ ...prev, done: !prev.done }))
  }

  return (
    <Pressable onPress={toggle}>
      <Text style={todo.done ? styles.done : undefined}>{todo.text}</Text>
    </Pressable>
  )
}
```

**When to use splitAtom vs selectAtom:**

| Use case                         | Tool        | Writable |
|----------------------------------|-------------|----------|
| Each list item reads + writes    | `splitAtom` | yes      |
| Derive a single value from list  | `selectAtom`| no       |
| Filter/search within list items  | `selectAtom`| no       |

Reference: [Jotai splitAtom](https://jotai.org/docs/utilities/split)
