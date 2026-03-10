#!/bin/bash
set -e

# Cleanup trap for temp files
TMPFILE=""
trap '[[ -n "$TMPFILE" ]] && rm -f "$TMPFILE"' EXIT

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install with: brew install jq" >&2
  exit 1
fi

BASE_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Detecting branch: $CURRENT_BRANCH (base: $BASE_BRANCH)" >&2

# Extract JIRA issue pattern from branch name (e.g. FE-1234, ABC-123)
JIRA_ISSUE=$(echo "$CURRENT_BRANCH" | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -n 1 || true)

echo "JIRA issue: ${JIRA_ISSUE:-none}" >&2

# Commits since diverging from base
echo "Gathering commits since $BASE_BRANCH..." >&2
COMMITS=$(git log "${BASE_BRANCH}..HEAD" --oneline 2>/dev/null || true)

# Diff stats
echo "Gathering diff stats..." >&2
DIFF_STAT=$(git diff "${BASE_BRANCH}...HEAD" --stat 2>/dev/null || true)

# Changed file list
CHANGED_FILES=$(git diff "${BASE_BRANCH}...HEAD" --name-only 2>/dev/null || true)

# Full diff truncated to 3000 lines
echo "Gathering diff content (truncated to 3000 lines)..." >&2
DIFF_CONTENT=$(git diff "${BASE_BRANCH}...HEAD" 2>/dev/null | head -n 3000 || true)

echo "Done. Outputting JSON..." >&2

# Build JSON output using jq for safe escaping
jq -n \
  --arg branch "$CURRENT_BRANCH" \
  --arg base_branch "$BASE_BRANCH" \
  --arg jira_issue "$JIRA_ISSUE" \
  --arg commits "$COMMITS" \
  --arg diff_stat "$DIFF_STAT" \
  --arg diff_content "$DIFF_CONTENT" \
  --arg changed_files "$CHANGED_FILES" \
  '{
    branch: $branch,
    base_branch: $base_branch,
    jira_issue: $jira_issue,
    commits: $commits,
    diff_stat: $diff_stat,
    diff_content: $diff_content,
    changed_files: $changed_files
  }'
