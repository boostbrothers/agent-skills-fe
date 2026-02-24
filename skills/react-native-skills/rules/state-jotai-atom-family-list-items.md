---
title: Use atomFamily for List Item Atoms in Virtualized Lists
impact: HIGH
impactDescription: prevents atom instance proliferation during FlashList cell recycling
tags: state, jotai, atomFamily, lists, flashlist, performance, re-render
---

## Use atomFamily for List Item Atoms in Virtualized Lists

Use `atomFamily` to create parameter-keyed atom factories for list item state.
When a list item component creates atoms dynamically (via `useMemo` or inline),
every mount produces a new atom instance. In FlashList/FlatList where cells are
rapidly mounted, unmounted, and recycled during scrolling, this leads to
excessive atom instances and growing Jotai store overhead.

`atomFamily` caches atom instances by parameter (typically an ID), so the same
key always returns the same atom—regardless of component lifecycle.

**Incorrect (useMemo atom — new instance on every mount, proliferates during scroll):**

```tsx
import { atom, useAtomValue } from 'jotai'
import { selectAtom } from 'jotai/utils'

const ordersAtom = atom<Record<string, Order>>({})

function OrderItem({ id }: { id: string }) {
  // Bad: new atom instance every time this component mounts
  // FlashList recycles cells → repeated mount/unmount → atom instances pile up
  const orderAtom = useMemo(
    () => selectAtom(ordersAtom, (orders) => orders[id]),
    [id]
  )
  const order = useAtomValue(orderAtom)

  return <Text>{order.title}</Text>
}
```

**Correct (atomFamily — cached by ID, single instance per key):**

```tsx
import { atom, useAtomValue } from 'jotai'
import { atomFamily, selectAtom } from 'jotai/utils'

const ordersAtom = atom<Record<string, Order>>({})

// Good: atomFamily caches by id — same id always returns the same atom
const orderAtomFamily = atomFamily((id: string) =>
  selectAtom(ordersAtom, (orders) => orders[id])
)

function OrderItem({ id }: { id: string }) {
  // Good: cache hit on re-mount — no new atom instance
  const order = useAtomValue(orderAtomFamily(id))

  return <Text>{order.title}</Text>
}
```

**Writable atomFamily with useSetAtom (read + write split):**

```tsx
import { atom, useAtomValue, useSetAtom } from 'jotai'
import { atomFamily } from 'jotai/utils'

interface CartItem {
  id: string
  name: string
  quantity: number
}

const cartAtom = atom<Record<string, CartItem>>({})

const cartItemAtomFamily = atomFamily((id: string) =>
  atom(
    (get) => get(cartAtom)[id],
    (get, set, update: Partial<CartItem>) => {
      const cart = get(cartAtom)
      set(cartAtom, { ...cart, [id]: { ...cart[id], ...update } })
    }
  )
)

// Read-only: only re-renders when this item's data changes
function CartItemDisplay({ id }: { id: string }) {
  const item = useAtomValue(cartItemAtomFamily(id))
  return <Text>{item.name} x{item.quantity}</Text>
}

// Write-only: never re-renders from value changes
function CartItemStepper({ id }: { id: string }) {
  const setItem = useSetAtom(cartItemAtomFamily(id))
  return (
    <Pressable onPress={() => setItem((prev) => ({ quantity: prev.quantity + 1 }))}>
      <Text>+</Text>
    </Pressable>
  )
}
```

**When to use atomFamily vs other patterns:**

| Use case                                  | Tool          | Key feature                    |
|-------------------------------------------|---------------|--------------------------------|
| Param-keyed atom for list items           | `atomFamily`  | instance caching by parameter  |
| Split a base array into per-item atoms    | `splitAtom`   | writable atoms from array      |
| Focus on a nested field in an object atom | `focusAtom`   | optics-based lens              |
| Read-only derived slice                   | `selectAtom`  | derived value subscription     |

Reference: [Jotai atomFamily](https://jotai.org/docs/utilities/family)
