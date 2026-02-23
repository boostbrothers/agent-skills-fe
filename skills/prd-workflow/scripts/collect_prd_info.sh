#!/bin/bash

# Function to get input using osascript
get_input() {
    local prompt="$1"
    local default_value="$2"
    local required="$3"
    local validation_type="$4" # "text", "url"

    while true; do
        input=$(osascript -e "text returned of (display dialog \"$prompt\" default answer \"$default_value\")" 2>/dev/null)

        # Check if user clicked "Cancel"
        if [ $? -ne 0 ]; then
            if [ "$required" = "true" ]; then
                echo "ERROR: $prompt is required. Execution cancelled." >&2
                exit 1
            else
                echo ""
                return
            fi
        fi

        # Trim whitespace
        trimmed_input=$(echo "$input" | xargs)

        # Validate required field
        if [ "$required" = "true" ] && [ -z "$trimmed_input" ]; then
            prompt="[REQUIRED - CANNOT BE EMPTY] $1"
            continue
        fi

        echo "$trimmed_input"
        return
    done
}

echo "--- PRD Information Collection ---"

# Required inputs
print_usage() {
    echo "Usage: $0 [--jira <KEY_OR_URL>]"
    echo "       $0 <KEY_OR_URL>"
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    print_usage
    exit 0
fi

jira_input=""

if [ "${1:-}" = "--jira" ] && [ -n "${2:-}" ]; then
    jira_input="$2"
elif [ -n "${1:-}" ]; then
    jira_input="$1"
elif [ -n "${JIRA_URL:-}" ]; then
    jira_input="$JIRA_URL"
else
    jira_input=$(get_input "JIRA Issue Key (e.g., PJD-1702) or URL:" "" "true" "text") || exit 1
fi

JIRA_URL="$jira_input"

echo "COLLECTED_DATA_START"
echo "JIRA: $JIRA_URL"
echo "COLLECTED_DATA_END"
