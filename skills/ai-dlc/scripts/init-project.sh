#!/bin/bash
set -e

# AI-DLC 프로젝트 구조 초기화 스크립트
# 신규 AI-DLC 프로젝트를 위한 aidlc-docs/ 폴더 구조를 생성합니다

PROJECT_ROOT="${1:-.}"

echo "AI-DLC 프로젝트 구조를 초기화합니다: $PROJECT_ROOT" >&2

# 디렉토리 구조 생성
mkdir -p "$PROJECT_ROOT/aidlc-docs/plans"
mkdir -p "$PROJECT_ROOT/aidlc-docs/requirements"
mkdir -p "$PROJECT_ROOT/aidlc-docs/story-artifacts"
mkdir -p "$PROJECT_ROOT/aidlc-docs/design-artifacts"

# 프롬프트 로그 파일이 없으면 생성
if [ ! -f "$PROJECT_ROOT/aidlc-docs/prompts.md" ]; then
  cat > "$PROJECT_ROOT/aidlc-docs/prompts.md" << 'EOF'
# AI-DLC 프롬프트 로그

이 AI-DLC 세션의 주요 프롬프트와 결정 사항이 여기에 기록됩니다.

---

EOF
  echo "prompts.md 생성 완료" >&2
fi

# 생성된 구조를 JSON으로 출력
echo '{"status":"success","structure":["aidlc-docs/plans/","aidlc-docs/requirements/","aidlc-docs/story-artifacts/","aidlc-docs/design-artifacts/","aidlc-docs/prompts.md"]}'

echo "AI-DLC 프로젝트 구조 초기화가 완료되었습니다." >&2
