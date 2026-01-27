## Use Framer Motion or CSS for Animations

**Impact: MEDIUM-HIGH**

Use Framer Motion for complex, interactive animations and transitions. For simple state-based animations (fade, slide, scale), use CSS with Tailwind utilities. Framer Motion provides declarative animation API, gesture support, and layout animations, while CSS is better for simple transitions.

**Choice Guidelines:**

- **Use Framer Motion for:** Complex sequences, gestures (drag/swipe), layout animations, orchestration, exit animations
- **Use CSS for:** Simple fade/slide, hover effects, loading states, basic transitions

## Framer Motion for Complex Animations

**Correct (Framer Motion for modal with exit animation):**

```tsx
import { motion, AnimatePresence } from 'framer-motion'

function Modal({ isOpen, onClose, children }: ModalProps) {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 bg-black/50"
          onClick={onClose}
        >
          <motion.div
            initial={{ scale: 0.9, opacity: 0, y: 20 }}
            animate={{ scale: 1, opacity: 1, y: 0 }}
            exit={{ scale: 0.9, opacity: 0, y: 20 }}
            transition={{ type: 'spring', damping: 25, stiffness: 300 }}
            className="bg-white rounded-xl p-6 m-4"
            onClick={(e) => e.stopPropagation()}
          >
            {children}
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
```

**Correct (gesture-driven interactions):**

```tsx
import { motion } from 'framer-motion'

function SwipeableCard({ onSwipe, children }: SwipeableCardProps) {
  return (
    <motion.div
      drag="x"
      dragConstraints={{ left: 0, right: 0 }}
      dragElastic={1}
      onDragEnd={(e, { offset, velocity }) => {
        const swipe = Math.abs(offset.x) * velocity.x
        if (swipe > 10000) {
          onSwipe(offset.x > 0 ? 'right' : 'left')
        }
      }}
      className="bg-white rounded-xl p-6 shadow-lg cursor-grab active:cursor-grabbing"
    >
      {children}
    </motion.div>
  )
}
```

**Correct (layout animations with shared layout):**

```tsx
import { motion, AnimatePresence } from 'framer-motion'

function ExpandableCard({ isExpanded, onToggle }: ExpandableCardProps) {
  return (
    <motion.div
      layout // Automatically animates layout changes
      className="bg-white rounded-xl p-6 cursor-pointer"
      onClick={onToggle}
    >
      <motion.h2 layout="position" className="text-xl font-bold">
        Title
      </motion.h2>
      
      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.3 }}
          >
            <p className="mt-4">Expanded content here...</p>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  )
}
```

**Correct (stagger children with orchestration):**

```tsx
import { motion } from 'framer-motion'

const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
    },
  },
}

const item = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0 },
}

function StaggeredList({ items }: { items: string[] }) {
  return (
    <motion.ul
      variants={container}
      initial="hidden"
      animate="show"
      className="space-y-2"
    >
      {items.map((text) => (
        <motion.li
          key={text}
          variants={item}
          className="p-4 bg-white rounded-lg shadow"
        >
          {text}
        </motion.li>
      ))}
    </motion.ul>
  )
}
```

**Correct (scroll-triggered animations):**

```tsx
import { motion, useScroll, useTransform } from 'framer-motion'

function ParallaxSection({ children }: { children: React.ReactNode }) {
  const { scrollYProgress } = useScroll()
  const y = useTransform(scrollYProgress, [0, 1], [0, -300])
  const opacity = useTransform(scrollYProgress, [0, 0.5, 1], [1, 0.5, 0])
  
  return (
    <motion.section style={{ y, opacity }}>
      {children}
    </motion.section>
  )
}
```

## CSS for Simple Animations

**Correct (simple fade/slide with Tailwind):**

```tsx
function FadeInBox({ show, children }: { show: boolean; children: React.ReactNode }) {
  return (
    <div
      className={`
        transition-all duration-300 ease-out
        ${show 
          ? 'opacity-100 translate-y-0' 
          : 'opacity-0 translate-y-5 pointer-events-none'
        }
      `}
    >
      {children}
    </div>
  )
}
```

**Correct (hover effects):**

```tsx
function Card({ children }: { children: React.ReactNode }) {
  return (
    <div className="
      bg-white rounded-xl p-6 shadow-lg
      transition-all duration-200
      hover:shadow-xl hover:scale-105
      active:scale-100
    ">
      {children}
    </div>
  )
}
```

**Correct (loading skeleton with CSS animation):**

```tsx
function LoadingSkeleton() {
  return (
    <div className="space-y-4">
      {[...Array(3)].map((_, i) => (
        <div
          key={i}
          className="
            h-20 rounded-lg
            bg-gradient-to-r from-gray-200 via-gray-100 to-gray-200
            bg-[length:200%_100%]
            animate-[shimmer_1.5s_infinite]
          "
        />
      ))}
    </div>
  )
}
```

```css
/* globals.css */
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
```

**Correct (tab transition with CSS):**

```tsx
function Tabs({ activeTab, setActiveTab }: TabsProps) {
  return (
    <div className="relative">
      <div className="flex gap-4 border-b">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`
              px-4 py-2 relative transition-colors
              ${activeTab === tab.id ? 'text-blue-500' : 'text-gray-500'}
            `}
          >
            {tab.label}
            {activeTab === tab.id && (
              <div className="
                absolute bottom-0 left-0 right-0 h-0.5 bg-blue-500
                animate-in slide-in-from-left duration-200
              " />
            )}
          </button>
        ))}
      </div>
    </div>
  )
}
```

## When to Choose Which

### Use Framer Motion when:
1. **Exit animations needed** - AnimatePresence handles unmount animations
2. **Gesture support** - Drag, swipe, pan with physics
3. **Layout animations** - Automatic FLIP animations with `layout` prop
4. **Orchestration** - Stagger, sequence, delay multiple animations
5. **Scroll-linked** - Parallax, scroll-triggered animations
6. **Complex sequences** - Multi-step animations with variants

### Use CSS when:
1. **Simple transitions** - Fade, slide, scale between states
2. **Hover effects** - Button hover, card lift
3. **Loading states** - Spinners, skeletons, progress bars
4. **Performance critical** - CSS runs on compositor thread
5. **Infinite loops** - Spinners, pulsing indicators

## Incorrect Patterns

**Incorrect (imperative animation with refs):**

```tsx
function BadAnimation() {
  const ref = useRef<HTMLDivElement>(null)
  
  useEffect(() => {
    // ❌ Imperative, hard to maintain
    let opacity = 0
    const animate = () => {
      opacity += 0.05
      if (ref.current) ref.current.style.opacity = String(opacity)
      if (opacity < 1) requestAnimationFrame(animate)
    }
    animate()
  }, [])
  
  return <div ref={ref}>Content</div>
}
```

**Incorrect (CSS for complex gestures):**

```tsx
// ❌ CSS can't handle drag physics properly
function DragCard() {
  return (
    <div className="cursor-grab active:cursor-grabbing" draggable>
      {/* Native drag is clunky, no physics */}
    </div>
  )
}
```

## Accessibility Considerations

**Correct (respect prefers-reduced-motion in Framer Motion):**

```tsx
import { motion, useReducedMotion } from 'framer-motion'

function AnimatedComponent() {
  const shouldReduceMotion = useReducedMotion()
  
  return (
    <motion.div
      initial={{ opacity: 0, y: shouldReduceMotion ? 0 : 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: shouldReduceMotion ? 0 : 0.3 }}
    >
      Content
    </motion.div>
  )
}
```

**Correct (global CSS for reduced motion):**

```css
/* globals.css */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Framer Motion Setup

**Installation:**

```bash
npm install framer-motion
```

**Common variant patterns:**

```tsx
// lib/motion-variants.ts
export const fadeInUp = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: 20 },
}

export const scaleIn = {
  initial: { scale: 0.8, opacity: 0 },
  animate: { scale: 1, opacity: 1 },
  exit: { scale: 0.8, opacity: 0 },
}

export const slideInLeft = {
  initial: { x: -100, opacity: 0 },
  animate: { x: 0, opacity: 1 },
  exit: { x: -100, opacity: 0 },
}

// Usage
import { motion } from 'framer-motion'
import { fadeInUp } from '@/lib/motion-variants'

function Component() {
  return (
    <motion.div {...fadeInUp} transition={{ duration: 0.3 }}>
      Content
    </motion.div>
  )
}
```

**Benefits of Framer Motion:**

1. **Declarative** - Animation defined in props, not imperative code
2. **Exit animations** - AnimatePresence handles unmounting gracefully
3. **Layout animations** - Automatic FLIP for layout changes
4. **Gesture support** - Drag, pan, swipe with physics out of the box
5. **TypeScript support** - Fully typed API
6. **Performance** - Hardware-accelerated, optimized for React

**Benefits of CSS:**

1. **Smaller bundle** - No JavaScript library (~50KB saved)
2. **Better performance** - Runs on compositor thread
3. **Simple to reason about** - State → className mapping
4. **Tailwind integration** - Utility classes for everything

Reference: [Framer Motion Documentation](https://www.framer.com/motion/)
