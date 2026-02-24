---
title: Use focusAtom to Subscribe to Nested State Fields
impact: MEDIUM
impactDescription: prevents re-renders from unrelated field changes
tags: state, jotai, focusAtom, optics, nested-state, re-render
---

## Use focusAtom to Subscribe to Nested State Fields

Use `focusAtom` from `jotai-optics` to create a writable sub-atom focused on
a specific field in a nested object. Components subscribing to the focused atom
only re-render when that exact field changes—not when sibling fields update.

**Incorrect (useAtom on entire object — any field change re-renders all consumers):**

```tsx
import { atom, useAtom } from 'jotai'

interface UserProfile {
  name: string
  email: string
  settings: {
    notifications: {
      push: boolean
      email: boolean
    }
    theme: 'light' | 'dark'
  }
}

const userProfileAtom = atom<UserProfile>({
  name: '',
  email: '',
  settings: {
    notifications: { push: true, email: true },
    theme: 'light',
  },
})

// Bad: re-renders when name, email, or theme changes
// even though it only cares about push notifications
function PushToggle() {
  const [profile, setProfile] = useAtom(userProfileAtom)

  const toggle = () => {
    setProfile((prev) => ({
      ...prev,
      settings: {
        ...prev.settings,
        notifications: {
          ...prev.settings.notifications,
          push: !prev.settings.notifications.push,
        },
      },
    }))
  }

  return (
    <Switch
      value={profile.settings.notifications.push}
      onValueChange={toggle}
    />
  )
}
```

**Correct (focusAtom — subscribes only to the target field):**

```tsx
import { atom, useAtom } from 'jotai'
import { focusAtom } from 'jotai-optics'

const userProfileAtom = atom<UserProfile>({
  name: '',
  email: '',
  settings: {
    notifications: { push: true, email: true },
    theme: 'light',
  },
})

// Focused atom: only tracks settings.notifications.push
const pushNotificationAtom = focusAtom(userProfileAtom, (optic) =>
  optic.prop('settings').prop('notifications').prop('push')
)

// Good: only re-renders when push notification value changes
function PushToggle() {
  const [pushEnabled, setPushEnabled] = useAtom(pushNotificationAtom)

  return <Switch value={pushEnabled} onValueChange={setPushEnabled} />
}
```

**Creating focused atoms for multiple fields:**

```tsx
const nameAtom = focusAtom(userProfileAtom, (optic) => optic.prop('name'))
const emailAtom = focusAtom(userProfileAtom, (optic) => optic.prop('email'))
const themeAtom = focusAtom(userProfileAtom, (optic) =>
  optic.prop('settings').prop('theme')
)

// Each component subscribes only to its own field
function NameEditor() {
  const [name, setName] = useAtom(nameAtom)
  return <TextInput value={name} onChangeText={setName} />
}

function ThemePicker() {
  const [theme, setTheme] = useAtom(themeAtom)
  return <SegmentedControl value={theme} onChange={setTheme} />
}
```

**When to use focusAtom vs selectAtom:**

| Use case                     | Tool         | Writable |
|------------------------------|--------------|----------|
| Read + write a nested field  | `focusAtom`  | yes      |
| Read-only derived slice      | `selectAtom` | no       |

Reference: [Jotai Optics — focusAtom](https://jotai.org/docs/extensions/optics)
