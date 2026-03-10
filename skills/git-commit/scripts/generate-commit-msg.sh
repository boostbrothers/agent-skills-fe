#!/bin/bash
set -e

# Cleanup trap for temp files
TMP_FILES=()
cleanup() {
  for f in "${TMP_FILES[@]}"; do
    rm -f "$f"
  done
}
trap cleanup EXIT

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install with: brew install jq" >&2
  exit 1
fi

echo "Gathering git context..." >&2

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Branch: $BRANCH" >&2

# Extract JIRA issue from branch name (e.g., feat/FE-4645 -> FE-4645)
JIRA_ISSUE=$(echo "$BRANCH" | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -n 1 || true)

# If no JIRA in branch, search recent commits
if [ -z "$JIRA_ISSUE" ]; then
  echo "No JIRA in branch, searching recent commits..." >&2
  JIRA_ISSUE=$(git log -10 --oneline | grep -oE '[A-Z][A-Z0-9]+-[0-9]+' | head -n 1 || true)
fi

if [ -n "$JIRA_ISSUE" ]; then
  echo "JIRA issue: $JIRA_ISSUE" >&2
else
  echo "No JIRA issue found" >&2
fi

# Get staged changes stat
STAGED_STAT=$(git diff --cached --stat || true)

if [ -z "$STAGED_STAT" ]; then
  echo "Warning: No staged changes detected. Run 'git add' first." >&2
fi

# Get staged diff (truncated to 2000 lines)
STAGED_DIFF=$(git diff --cached | head -n 2000 || true)

# Get recent commits for context
RECENT_COMMITS=$(git log -5 --oneline || true)

echo "Context gathered successfully." >&2

# Output JSON
jq -n \
  --arg branch "$BRANCH" \
  --arg jira_issue "$JIRA_ISSUE" \
  --arg staged_stat "$STAGED_STAT" \
  --arg staged_diff "$STAGED_DIFF" \
  --arg recent_commits "$RECENT_COMMITS" \
  '{
    branch: $branch,
    jira_issue: $jira_issue,
    staged_stat: $staged_stat,
    staged_diff: $staged_diff,
    recent_commits: $recent_commits
  }'
