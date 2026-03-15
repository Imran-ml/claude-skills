#!/usr/bin/env bash
# ─── Post-Tool Logging Hook ─────────────────────────────────────────────────
#
# Runs AFTER every successful tool call (async — doesn't block Claude).
# Logs tool usage to ~/.claude/tool-usage.log
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

INPUT=$(cat)
LOG_FILE="${HOME}/.claude/tool-usage.log"

# Extract fields
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))" 2>/dev/null || echo "unknown")
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_id',''))" 2>/dev/null || echo "")
CWD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('cwd',''))" 2>/dev/null || echo "")
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# Append to log
echo "${TIMESTAMP} | session=${SESSION_ID} | tool=${TOOL_NAME} | cwd=${CWD}" >> "$LOG_FILE"

exit 0
