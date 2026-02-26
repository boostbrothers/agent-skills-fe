---
title: Color & Styling Conventions
impact: CRITICAL
impactDescription: 디자인 시스템 색상 및 스타일 일관성의 기반
tags: [color, token, nativewind, lineheight, inline-style, design-system]
---

## Color & Styling Conventions

**Impact: CRITICAL**

inline `style={{ backgroundColor/color }}` 대신 NativeWind 클래스를 사용한다. 컬러는 반드시 colors.ts에 정의된 토큰을 NativeWind className 패턴으로 참조한다.

**Token Reference:**

```
White: #FFFFFF
Yellow:      700 #FFDB00 | 450 #FFE43F | 400 #FFED49 | 100 #FFF8B6 | 50 #FFFBDB
CoolGray:    900 #2C3744 | 850 #36475A | 800 #506073 | 700 #5F6972 | 500 #80878F
             400 #959BA1 | 300 #ABAFB4 | 200 #E5E8EB | 100 #EDF0F3 | 50 #F5F7F9 | 10 #FBFCFD
NeutralGray: 900 #303133 | 400 #939393 | 300 #AFAFAF | 100 #DFDFDF | 50 #E5E5E5
FeedBackColor: 300 #F55251 | 200 #F75E5F | 100 #FD857C | 50 #FFC5C0 | 10 #FFF0EF
Blue:        300 #0077D1 | 50 #E7F6FF | 10 #F4FBFF
Green:       300 #77C700 | 50 #EDFAD0
DimmedEffect: 40 rgba(0,0,0,0.4) | 4 rgba(0,0,0,0.04)
```

**NativeWind Class Patterns:**

```
배경색: bg-{ColorName}-{shade}     예: bg-Yellow-400, bg-CoolGray-50
텍스트: text-{ColorName}-{shade}   예: text-CoolGray-900, text-Blue-300
보더:   border-{ColorName}-{shade} 예: border-CoolGray-200
흰색:   bg-white, text-white
```

**Incorrect:**

```tsx
// hex 값 직접 사용 금지
<View style={{ backgroundColor: '#FFDB00' }} />
<Text style={{ color: '#2C3744' }} />
<View style={{ borderColor: '#E5E8EB' }} />
```

**Correct:**

```tsx
// NativeWind 토큰 클래스 사용
<View className="bg-Yellow-700" />
<Text className="text-CoolGray-900" />
<View className="bg-CoolGray-50 border border-CoolGray-200" />
<Text className="text-Blue-300" />
<View className="bg-white" />
```

**LineHeight Override:**

```tsx
// 텍스트 스타일 클래스는 lineHeight를 포함한다.
// 피그마 디자인의 lineHeight가 클래스 기본값과 다르면 leading-[Xpx]로 오버라이드한다.

// Caption12Regular(12px/20px)인데 피그마에서 lineHeight가 16px인 경우
<Text className="text-Caption12Regular leading-[16px]" />

// Body14Regular(14px/22px)인데 피그마에서 lineHeight가 18px인 경우
<Text className="text-Body14Regular leading-[18px]" />

// 피그마 lineHeight와 클래스 기본값이 동일하면 오버라이드 불필요
<Text className="text-Body16Regular" />
```

**Allowed (tintColor):**

```tsx
// Image 컴포넌트의 tintColor — RN 전용 속성, NativeWind 미지원
<Image style={{ tintColor: Colors.White }} source={icon} />
<Image style={{ tintColor: isOwn ? Colors.Blue[300] : Colors.CoolGray[500] }} source={icon} />
```

**Allowed (animation):**

```tsx
// Reanimated animated style — NativeWind와 혼용 불가
const animatedStyle = useAnimatedStyle(() => ({
  opacity: withTiming(isVisible.value ? 1 : 0),
  transform: [{ translateY: withSpring(offsetY.value) }],
}))

<Animated.View style={animatedStyle} className="bg-white" />
```
