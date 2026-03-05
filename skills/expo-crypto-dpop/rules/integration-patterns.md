---
title: Integration Patterns
impact: REFERENCE
impactDescription: Axios 기반 API 클라이언트에 DPoP 인증을 통합하는 실무 패턴
tags: [dpop, axios, interceptor, nonce, token-refresh, integration]
---

**1. Axios 요청 인터셉터**

DPoP가 필요한 요청에만 선택적으로 DPoP 헤더를 추가. 요청 config에 `dpop: true`를 설정한 경우에만 적용된다:

```typescript
import axios, { InternalAxiosRequestConfig } from 'axios';
import { createProof } from 'expo-crypto-dpop';

// Axios config 타입 확장
declare module 'axios' {
  interface AxiosRequestConfig {
    dpop?: boolean;
  }
}

const apiClient = axios.create({ baseURL: 'https://api.example.com' });

apiClient.interceptors.request.use(async (config) => {
  if (!config.dpop) return config;

  const url = new URL(config.url!, config.baseURL);
  const htu = url.origin + url.pathname; // 쿼리 파라미터 제외!

  const proof = await createProof({
    htm: config.method!.toUpperCase(),
    htu,
    accessToken: getStoredAccessToken(),
  });

  config.headers['DPoP'] = proof;
  return config;
});
```

**사용 예시:**

```typescript
// DPoP 적용 O
apiClient.get('/protected/resource', { dpop: true });

// DPoP 적용 X (기본값)
apiClient.get('/public/resource');
```

> ⚠️ `htu`는 RFC 9449에 따라 `origin + pathname`만 사용. 쿼리 파라미터와 프래그먼트 포함 금지.

**2. Nonce 처리 (use_dpop_nonce)**

서버가 재전송 공격 방지를 위해 nonce를 요구할 경우:

```typescript
let dpopNonce: string | undefined;

apiClient.interceptors.response.use(
  (response) => {
    // 성공 응답에서도 nonce 업데이트
    const newNonce = response.headers['dpop-nonce'];
    if (newNonce) dpopNonce = newNonce;
    return response;
  },
  async (error) => {
    const config = error.config;
    if (!config?.dpop) return Promise.reject(error);

    if (error.response?.status === 401) {
      const wwwAuth = error.response.headers['www-authenticate'] || '';
      const nonceMatch = wwwAuth.match(/DPoP-Nonce="([^"]+)"/);

      if (nonceMatch) {
        dpopNonce = nonceMatch[1];
        // nonce를 포함하여 재시도
        const url = new URL(config.url!, config.baseURL);
        const proof = await createProof({
          htm: config.method!.toUpperCase(),
          htu: url.origin + url.pathname,
          accessToken: getStoredAccessToken(),
          nonce: dpopNonce,
        });
        config.headers['DPoP'] = proof;
        return apiClient.request(config);
      }
    }
    return Promise.reject(error);
  }
);
```

**3. 토큰 갱신 흐름**

액세스 토큰 만료 시:
- 갱신 요청에도 DPoP 증명 필수
- 동시 요청 방지를 위한 갱신 큐 관리

```typescript
let isRefreshing = false;
let refreshQueue: Array<(token: string) => void> = [];

async function refreshAccessToken(): Promise<string> {
  if (isRefreshing) {
    return new Promise((resolve) => refreshQueue.push(resolve));
  }
  isRefreshing = true;

  const proof = await createProof({
    htm: 'POST',
    htu: 'https://api.example.com/oauth/token',
  });

  const response = await axios.post('https://api.example.com/oauth/token', {
    grant_type: 'refresh_token',
    refresh_token: getStoredRefreshToken(),
  }, {
    headers: { 'DPoP': proof },
  });

  const newToken = response.data.access_token;
  storeAccessToken(newToken);
  refreshQueue.forEach((resolve) => resolve(newToken));
  refreshQueue = [];
  isRefreshing = false;
  return newToken;
}
```

**4. 앱 초기화**

```typescript
import { ensureKeyPair } from 'expo-crypto-dpop';

// App.tsx 또는 앱 시작점
useEffect(() => {
  ensureKeyPair().catch(console.error);
}, []);
```

**5. 로그아웃 처리**

```typescript
import { deleteKeyPair } from 'expo-crypto-dpop';

async function logout() {
  clearStoredTokens();
  await deleteKeyPair(); // 선택사항: 보안 정책에 따라 결정
}
```
