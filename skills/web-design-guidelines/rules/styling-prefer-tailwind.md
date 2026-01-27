## Prefer Tailwind CSS for Styling

**Impact: HIGH**

Use Tailwind CSS utility classes instead of custom CSS or inline styles. Tailwind provides a consistent design system, reduces CSS bundle size through purging, and improves developer velocity with auto-complete and no naming conflicts.

**Incorrect (custom CSS with naming conflicts):**

```tsx
// styles.css
.button {
  padding: 12px 24px;
  border-radius: 8px;
  background-color: #3b82f6;
  color: white;
  font-weight: 600;
}

.button:hover {
  background-color: #2563eb;
}

.button-large {
  padding: 16px 32px;
  font-size: 18px;
}

// Component
import './styles.css'

function Button({ size = 'default' }) {
  return (
    <button className={`button ${size === 'large' ? 'button-large' : ''}`}>
      Click me
    </button>
  )
}
```

**Incorrect (inline styles - no reusability):**

```tsx
function Button() {
  return (
    <button
      style={{
        padding: '12px 24px',
        borderRadius: '8px',
        backgroundColor: '#3b82f6',
        color: 'white',
        fontWeight: 600,
      }}
    >
      Click me
    </button>
  )
}
```

**Correct (Tailwind utility classes):**

```tsx
function Button({ size = 'default' }: { size?: 'default' | 'large' }) {
  return (
    <button
      className={`
        rounded-lg bg-blue-500 text-white font-semibold 
        hover:bg-blue-600 active:bg-blue-700
        transition-colors duration-150
        ${size === 'large' ? 'px-8 py-4 text-lg' : 'px-6 py-3'}
      `}
    >
      Click me
    </button>
  )
}
```

**Correct (with clsx for conditional classes):**

```tsx
import clsx from 'clsx'

function Button({ 
  size = 'default', 
  variant = 'primary',
  disabled = false 
}: ButtonProps) {
  return (
    <button
      className={clsx(
        // Base styles
        'rounded-lg font-semibold transition-colors duration-150',
        // Size variants
        {
          'px-6 py-3 text-base': size === 'default',
          'px-8 py-4 text-lg': size === 'large',
          'px-4 py-2 text-sm': size === 'small',
        },
        // Color variants
        {
          'bg-blue-500 text-white hover:bg-blue-600': variant === 'primary',
          'bg-gray-200 text-gray-900 hover:bg-gray-300': variant === 'secondary',
          'bg-transparent border-2 border-blue-500 text-blue-500 hover:bg-blue-50': variant === 'outline',
        },
        // Disabled state
        disabled && 'opacity-50 cursor-not-allowed pointer-events-none'
      )}
      disabled={disabled}
    >
      Click me
    </button>
  )
}
```

**Correct (extract to reusable component variants with cva):**

```tsx
import { cva, type VariantProps } from 'class-variance-authority'

const buttonVariants = cva(
  // Base styles
  'rounded-lg font-semibold transition-colors duration-150 disabled:opacity-50 disabled:cursor-not-allowed',
  {
    variants: {
      variant: {
        primary: 'bg-blue-500 text-white hover:bg-blue-600 active:bg-blue-700',
        secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300 active:bg-gray-400',
        outline: 'bg-transparent border-2 border-blue-500 text-blue-500 hover:bg-blue-50',
        ghost: 'bg-transparent text-gray-700 hover:bg-gray-100',
        danger: 'bg-red-500 text-white hover:bg-red-600 active:bg-red-700',
      },
      size: {
        small: 'px-4 py-2 text-sm',
        default: 'px-6 py-3 text-base',
        large: 'px-8 py-4 text-lg',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'default',
    },
  }
)

type ButtonProps = VariantProps<typeof buttonVariants> & {
  children: React.ReactNode
  disabled?: boolean
}

function Button({ variant, size, disabled, children }: ButtonProps) {
  return (
    <button className={buttonVariants({ variant, size })} disabled={disabled}>
      {children}
    </button>
  )
}
```

**Tailwind configuration for design system:**

```js
// tailwind.config.js
module.exports = {
  content: ['./src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          500: '#3b82f6',
          600: '#2563eb',
          900: '#1e3a8a',
        },
        // Custom brand colors
        brand: {
          light: '#f0f9ff',
          DEFAULT: '#0ea5e9',
          dark: '#0369a1',
        },
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
      },
      borderRadius: {
        'xl': '1rem',
        '2xl': '1.5rem',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
```

**Correct (responsive design with Tailwind):**

```tsx
function Card({ title, description, image }: CardProps) {
  return (
    <div className="
      bg-white rounded-xl shadow-lg overflow-hidden
      hover:shadow-xl transition-shadow duration-300
      
      /* Mobile: stack vertically */
      flex flex-col
      
      /* Tablet: side by side */
      md:flex-row
      
      /* Desktop: larger spacing */
      lg:p-6
    ">
      <img 
        src={image} 
        alt={title}
        className="
          w-full h-48 object-cover
          md:w-1/3 md:h-auto
        "
      />
      <div className="p-4 md:p-6 lg:p-8">
        <h3 className="text-xl md:text-2xl lg:text-3xl font-bold mb-2">
          {title}
        </h3>
        <p className="text-gray-600 text-sm md:text-base">
          {description}
        </p>
      </div>
    </div>
  )
}
```

**Correct (custom utilities via @layer):**

```css
/* globals.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  .scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  .scrollbar-hide::-webkit-scrollbar {
    display: none;
  }
  
  .text-balance {
    text-wrap: balance;
  }
}

@layer components {
  .btn-primary {
    @apply px-6 py-3 bg-blue-500 text-white rounded-lg font-semibold;
    @apply hover:bg-blue-600 active:bg-blue-700;
    @apply transition-colors duration-150;
    @apply disabled:opacity-50 disabled:cursor-not-allowed;
  }
}
```

**Benefits of Tailwind CSS:**

1. **Consistency** - Design tokens ensure consistent spacing, colors, and sizing
2. **No naming conflicts** - No need to invent class names (BEM, SMACSS)
3. **Smaller bundles** - Purge removes unused CSS (typically 5-10KB final size)
4. **Better DX** - IntelliSense auto-complete for all utilities
5. **Responsive by default** - Breakpoint prefixes (sm:, md:, lg:, xl:, 2xl:)
6. **Dark mode ready** - Built-in dark: prefix for dark mode variants
7. **Maintainable** - All styles co-located with components

Reference: [Tailwind CSS Documentation](https://tailwindcss.com/docs)
