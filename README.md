# Agent Skills

A collection of skills for AI coding agents. Skills are packaged instructions and scripts that extend agent capabilities.

Skills follow the [Agent Skills](https://agentskills.io/) format.

## Available Skills

### react-best-practices

React and Next.js performance optimization guidelines from Vercel Engineering. Contains 40+ rules across 8 categories, prioritized by impact.

**Use when:**
- Writing new React components or Next.js pages
- Implementing data fetching (client or server-side)
- Reviewing code for performance issues
- Optimizing bundle size or load times

**Categories covered:**
- Eliminating waterfalls (Critical)
- Bundle size optimization (Critical)
- Server-side performance (High)
- Client-side data fetching (Medium-High)
- Re-render optimization (Medium)
- Rendering performance (Medium)
- JavaScript micro-optimizations (Low-Medium)

### web-design-guidelines

Review UI code for compliance with web interface best practices. Audits your code for 100+ rules covering accessibility, performance, and UX.

**Use when:**
- "Review my UI"
- "Check accessibility"
- "Audit design"
- "Review UX"
- "Check my site against best practices"

**Categories covered:**
- Accessibility (aria-labels, semantic HTML, keyboard handlers)
- Focus States (visible focus, focus-visible patterns)
- Forms (autocomplete, validation, error handling)
- Animation (prefers-reduced-motion, compositor-friendly transforms)
- Typography (curly quotes, ellipsis, tabular-nums)
- Images (dimensions, lazy loading, alt text)
- Performance (virtualization, layout thrashing, preconnect)
- Navigation & State (URL reflects state, deep-linking)
- Dark Mode & Theming (color-scheme, theme-color meta)
- Touch & Interaction (touch-action, tap-highlight)
- Locale & i18n (Intl.DateTimeFormat, Intl.NumberFormat)

### react-native-guidelines

React Native best practices optimized for AI agents. Contains 16 rules across 7 sections covering performance, architecture, and platform-specific patterns.

**Use when:**
- Building React Native or Expo apps
- Optimizing mobile performance
- Implementing animations or gestures
- Working with native modules or platform APIs

**Categories covered:**
- Performance (Critical) - FlashList, memoization, heavy computation
- Layout (High) - flex patterns, safe areas, keyboard handling
- Animation (High) - Reanimated, gesture handling
- Images (Medium) - expo-image, caching, lazy loading
- State Management (Medium) - Zustand patterns, React Compiler
- Architecture (Medium) - monorepo structure, imports
- Platform (Medium) - iOS/Android specific patterns

### composition-patterns

React composition patterns that scale. Helps avoid boolean prop proliferation through compound components, state lifting, and internal composition.

**Use when:**
- Refactoring components with many boolean props
- Building reusable component libraries
- Designing flexible APIs
- Reviewing component architecture

**Patterns covered:**
- Extracting compound components
- Lifting state to reduce props
- Composing internals for flexibility
- Avoiding prop drilling

### react-native-naver-map

네이버 지도 SDK React Native 래퍼. 10개 오버레이 컴포넌트, 카메라 제어, 마커 클러스터링, 위치 추적 기능 포함.

**Use when:**
- 네이버 지도 컴포넌트 구현 시
- 마커, 경로선, 폴리곤 등 오버레이 추가 시
- 카메라 애니메이션, 좌표 변환 작업 시
- 마커 클러스터링 구현 시

**Categories covered:**
- Component API (10 components: NaverMapView, Marker, InfoWindow, Path, Polyline, Polygon, Circle, Arrowhead, MultiPath, Ground)
- Types & Enums (Camera, Coord, Region, MapType, LocationTrackingMode)
- Troubleshooting (iOS/Android build, Expo, clustering)

### expo-crypto-dpop

RFC 9449 DPoP 인증 모듈. EC P-256 키 생성, DPoP 증명 JWT 생성, 보안 키 저장 기능.

**Use when:**
- DPoP 인증 구현 시
- OAuth 2.0 토큰 바인딩이 필요할 때
- Axios 인터셉터에 DPoP 헤더 추가 시

**Categories covered:**
- API Reference (ensureKeyPair, createProof, deleteKeyPair)
- DPoP JWT Structure (ES256, ath claim, nonce)
- Integration Patterns (Axios interceptor, nonce handling, token refresh)

### react-native-kms-module

AWS KMS 네이티브 암호화/복호화 모듈. 엔벨로프 암호화 패턴, AES-256-ECB 로컬 암호화.

**Use when:**
- AWS KMS를 사용한 데이터 암호화/복호화 시
- 엔벨로프 암호화 패턴 이해가 필요할 때

**Categories covered:**
- API Reference (init, encrypt, decrypt)
- Envelope Encryption Architecture
- Security Guidelines (credential management)

### react-native-coucon-sdk

Coucon SAS 인증 TurboModule SDK. NativeEventEmitter 기반 비동기 결과 처리.

**Use when:**
- Coucon SAS 인증 구현 시
- TurboModule 기반 네이티브 모듈 연동 시

**Categories covered:**
- API Reference (initialize, run, addOnSASRunCompletedListener)
- Critical Pattern (listener-before-run ordering)
- Event Structure (onSASRunCompleted)

### react-native-device-data-module

iOS UserDefaults / Android SharedPreferences 통합 인터페이스. 플랫폼별 키 매핑, 동적 키, 값 변환.

**Use when:**
- 네이티브 스토리지에 접근할 때
- 플랫폼 간 키 매핑이 필요할 때
- 토큰, 디바이스 ID 등 저장된 값을 읽을 때

**Categories covered:**
- Unified Key System (13+ keys)
- Platform Key Mapping (iOS/Android full table)
- Edge Cases (dynamic keys, JSON transform, timestamp normalization)

### react-native-live-activity

iOS Live Activity로 병원 접수 상태를 잠금 화면과 Dynamic Island에 실시간 표시.

**Use when:**
- iOS Live Activity 구현 시
- 병원 접수 상태 실시간 표시 시
- ActivityKit 관련 작업 시

**Categories covered:**
- API Reference (requestLiveActivities, updateReceptionState, endAllActivities, areActivitiesEnabled)
- State Machine (pending → waiting → inProgress → completed)
- Type Definitions (ReceptionStateLiveActivityItem, UpdateReceptionStateParams)

### vercel-deploy-claimable

Deploy applications and websites to Vercel instantly. Designed for use with claude.ai and Claude Desktop to enable deployments directly from conversations. Deployments are "claimable" - users can transfer ownership to their own Vercel account.

**Use when:**
- "Deploy my app"
- "Deploy this to production"
- "Push this live"
- "Deploy and give me the link"

**Features:**
- Auto-detects 40+ frameworks from `package.json`
- Returns preview URL (live site) and claim URL (transfer ownership)
- Handles static HTML projects automatically
- Excludes `node_modules` and `.git` from uploads

**How it works:**
1. Packages your project into a tarball
2. Detects framework (Next.js, Vite, Astro, etc.)
3. Uploads to deployment service
4. Returns preview URL and claim URL

**Output:**
```
Deployment successful!

Preview URL: https://skill-deploy-abc123.vercel.app
Claim URL:   https://vercel.com/claim-deployment?code=...
```

## Installation

```bash
npx skills add boostbrothers/agent-skills-fe
```

## Usage

Skills are automatically available once installed. The agent will use them when relevant tasks are detected.

**Examples:**
```
Deploy my app
```
```
Review this React component for performance issues
```
```
Help me optimize this Next.js page
```

## Skill Structure

Each skill contains:
- `SKILL.md` - Instructions for the agent
- `scripts/` - Helper scripts for automation (optional)
- `references/` - Supporting documentation (optional)

## License

MIT
