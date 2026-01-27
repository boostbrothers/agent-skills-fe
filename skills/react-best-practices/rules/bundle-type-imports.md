---
title: Use Explicit Type Imports
impact: MEDIUM
impactDescription: prevents runtime imports of types, smaller bundles
tags: bundle, imports, typescript, types, tree-shaking
---

## Use Explicit Type Imports

Always use `import type` or inline `type` modifier when importing types. This ensures TypeScript types are completely erased at compile time and prevents accidental runtime imports.

**Incorrect (ambiguous imports):**

```tsx
import { User, UserRole, fetchUser } from './user'
// TypeScript can't guarantee User and UserRole won't be in runtime bundle
// If User is a class (not just a type), it will be included unnecessarily

import { ComponentProps, useState, ReactNode } from 'react'
// ComponentProps and ReactNode are types but imported alongside runtime values
```

**Incorrect (mixed without type modifier):**

```tsx
import { User } from './types'
import { fetchUser } from './api'

function Profile({ user }: { user: User }) {
  // ...
}
```

**Correct (separate type imports):**

```tsx
import type { User, UserRole } from './user'
import { fetchUser } from './user'

function Profile({ user }: { user: User }) {
  // User is guaranteed to be erased at compile time
}
```

**Correct (inline type modifier - preferred):**

```tsx
import { type User, type UserRole, fetchUser } from './user'

// Or for React imports
import { type ComponentProps, type ReactNode, useState, useEffect } from 'react'

function Button({ children }: { children: ReactNode }) {
  const [active, setActive] = useState(false)
  return <button>{children}</button>
}
```

**Correct (type-only re-exports):**

```tsx
// types.ts
export type { User, UserRole } from './user'
export type { Product, ProductCategory } from './product'

// index.ts - re-exporting types
export type { User, UserRole } from './types'
export { fetchUser, updateUser } from './api'
```

**ESLint configuration:**

```json
{
  "rules": {
    "@typescript-eslint/consistent-type-imports": [
      "error",
      {
        "prefer": "type-imports",
        "fixStyle": "inline-type-imports"
      }
    ]
  }
}
```

**Why explicit type imports matter:**

1. **Smaller bundles** - Types are guaranteed to be erased
2. **Faster builds** - Bundler can skip type-only modules entirely
3. **Clearer intent** - Distinguishes runtime values from compile-time types
4. **Avoids circular dependency issues** - Type-only imports don't cause runtime cycles

Reference: [TypeScript 3.8 Type-Only Imports and Export](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-8.html#type-only-imports-and-export)
