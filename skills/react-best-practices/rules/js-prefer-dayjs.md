---
title: Prefer dayjs Over Native Date
impact: MEDIUM
impactDescription: consistent date handling, timezone safety, smaller bundle
tags: js, date, dayjs, timezone, formatting, parsing
---

## Prefer dayjs Over Native Date

Use `dayjs` instead of native `Date` for date manipulation. dayjs provides immutable operations, consistent parsing, timezone support, and a cleaner API while being only ~2KB gzipped.

**Incorrect (native Date - mutable and inconsistent):**

```tsx
function formatDate(date: Date) {
  // ❌ Native Date formatting is verbose and locale-dependent
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

function addDays(date: Date, days: number) {
  // ❌ Mutates the original date object
  date.setDate(date.getDate() + days)
  return date
}

// Usage
const today = new Date()
const nextWeek = addDays(today, 7)
console.log(today) // ❌ today is also modified!
```

**Correct (dayjs - immutable and consistent):**

```tsx
import dayjs from 'dayjs'

function formatDate(date: dayjs.Dayjs | Date | string) {
  // ✅ Clean, chainable API
  return dayjs(date).format('YYYY-MM-DD')
}

function addDays(date: dayjs.Dayjs | Date | string, days: number) {
  // ✅ Returns new instance, original unchanged
  return dayjs(date).add(days, 'day')
}

// Usage
const today = dayjs()
const nextWeek = addDays(today, 7)
console.log(today.format()) // ✅ today is unchanged
```

**Incorrect (timezone issues with native Date):**

```tsx
function parseServerDate(isoString: string) {
  // ❌ Parsed in local timezone, causes bugs
  const date = new Date(isoString)
  return date.toLocaleDateString()
}

function getStartOfDay(date: Date) {
  // ❌ Timezone-naive, may give wrong date
  return new Date(date.getFullYear(), date.getMonth(), date.getDate())
}
```

**Correct (timezone-aware with dayjs):**

```tsx
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'

dayjs.extend(utc)
dayjs.extend(timezone)

function parseServerDate(isoString: string) {
  // ✅ Explicit timezone handling
  return dayjs.utc(isoString).local().format('YYYY-MM-DD')
}

function getStartOfDay(date: dayjs.Dayjs, tz: string = 'Asia/Seoul') {
  // ✅ Timezone-aware start of day
  return dayjs(date).tz(tz).startOf('day')
}
```

**Incorrect (complex date calculations):**

```tsx
function getRelativeTime(date: Date) {
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  
  // ❌ Manual, error-prone relative time calculation
  if (days === 0) return '오늘'
  if (days === 1) return '어제'
  if (days < 7) return `${days}일 전`
  // ... more complex logic
}

function getMonthRange(year: number, month: number) {
  // ❌ Verbose and easy to get wrong
  const start = new Date(year, month, 1)
  const end = new Date(year, month + 1, 0)
  return { start, end }
}
```

**Correct (dayjs plugins for complex operations):**

```tsx
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import 'dayjs/locale/ko'

dayjs.extend(relativeTime)
dayjs.locale('ko')

function getRelativeTime(date: dayjs.Dayjs | Date | string) {
  // ✅ Built-in relative time with localization
  return dayjs(date).fromNow() // "3일 전", "2시간 전"
}

function getMonthRange(year: number, month: number) {
  const target = dayjs().year(year).month(month)
  // ✅ Clean API for date ranges
  return {
    start: target.startOf('month'),
    end: target.endOf('month')
  }
}
```

**Incorrect (date comparison with native Date):**

```tsx
function isExpired(expiryDate: Date) {
  // ❌ Comparing Date objects directly is unreliable
  return new Date() > expiryDate
}

function isSameDay(date1: Date, date2: Date) {
  // ❌ Verbose comparison
  return date1.getFullYear() === date2.getFullYear() &&
         date1.getMonth() === date2.getMonth() &&
         date1.getDate() === date2.getDate()
}
```

**Correct (dayjs comparison methods):**

```tsx
import dayjs from 'dayjs'
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore'

dayjs.extend(isSameOrBefore)

function isExpired(expiryDate: dayjs.Dayjs | Date | string) {
  // ✅ Clear, readable comparison
  return dayjs().isAfter(expiryDate)
}

function isSameDay(date1: dayjs.Dayjs, date2: dayjs.Dayjs) {
  // ✅ Built-in comparison with granularity
  return date1.isSame(date2, 'day')
}

function isWithinRange(date: dayjs.Dayjs, start: dayjs.Dayjs, end: dayjs.Dayjs) {
  // ✅ Range checking
  return date.isSameOrAfter(start, 'day') && date.isSameOrBefore(end, 'day')
}
```

**Recommended dayjs setup:**

```tsx
// lib/dayjs.ts - centralized configuration
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import relativeTime from 'dayjs/plugin/relativeTime'
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore'
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter'
import 'dayjs/locale/ko'

// Extend with commonly used plugins
dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.extend(relativeTime)
dayjs.extend(isSameOrBefore)
dayjs.extend(isSameOrAfter)

// Set default timezone and locale
dayjs.tz.setDefault('Asia/Seoul')
dayjs.locale('ko')

export default dayjs
```

```tsx
// Usage in components
import dayjs from '@/lib/dayjs'

function EventCard({ event }: { event: Event }) {
  const eventDate = dayjs(event.date)
  
  return (
    <div>
      <time dateTime={eventDate.toISOString()}>
        {eventDate.format('YYYY년 M월 D일 (ddd)')}
      </time>
      <span>{eventDate.fromNow()}</span>
    </div>
  )
}
```

**Why dayjs over native Date:**

1. **Immutable** - Operations return new instances, preventing mutation bugs
2. **Chainable API** - Clean, readable date manipulation
3. **Timezone support** - Proper timezone handling with plugins
4. **Localization** - Built-in i18n for 100+ locales
5. **Small size** - ~2KB gzipped (vs moment.js ~70KB)
6. **Consistent parsing** - Reliable across browsers and environments

Reference: [dayjs Documentation](https://day.js.org/)
