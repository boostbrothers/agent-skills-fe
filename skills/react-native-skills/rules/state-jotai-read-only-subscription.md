---
title: Use useAtomValue and useSetAtom for Minimal Subscriptions
impact: MEDIUM
impactDescription: avoids unnecessary re-renders from unused subscriptions
tags: state, jotai, useAtomValue, useSetAtom, re-render, subscription
---

## Use useAtomValue and useSetAtom for Minimal Subscriptions

When a component only reads an atom, use `useAtomValue`. When it only writes,
use `useSetAtom`. `useSetAtom` does not subscribe to value changes—the
component won't re-render when the atom's value updates.

`useAtom` subscribes to both read and write. Use it only when the component
genuinely needs both.

**Incorrect (useAtom when only writing — subscribes to value changes needlessly):**

```tsx
import { useAtom } from 'jotai'
import { countAtom } from './atoms'

// Bad: this component re-renders every time countAtom changes,
// even though it never reads the value
function IncrementButton() {
  const [count, setCount] = useAtom(countAtom)

  return <Button title="+" onPress={() => setCount((c) => c + 1)} />
}
```

**Correct (useSetAtom — no subscription, zero re-renders from value changes):**

```tsx
import { useSetAtom } from 'jotai'
import { countAtom } from './atoms'

// Good: no subscription to countAtom's value — never re-renders from count changes
function IncrementButton() {
  const setCount = useSetAtom(countAtom)

  return <Button title="+" onPress={() => setCount((c) => c + 1)} />
}
```

**Correct (useAtomValue — read-only subscription):**

```tsx
import { useAtomValue } from 'jotai'
import { countAtom } from './atoms'

// Good: explicitly read-only — makes intent clear
function CountDisplay() {
  const count = useAtomValue(countAtom)

  return <Text>{count}</Text>
}
```

**Quick reference:**

| Hook           | Reads | Writes | Subscribes to changes |
|----------------|-------|--------|-----------------------|
| `useAtom`      | yes   | yes    | yes                   |
| `useAtomValue`  | yes   | no     | yes                   |
| `useSetAtom`   | no    | yes    | no                    |

Reference: [Jotai Core — useAtom](https://jotai.org/docs/core/use-atom)
