#!/usr/bin/env bash
# ─── Pre-Bash Check Hook ────────────────────────────────────────────────────
#
# Runs BEFORE every Bash tool call.
# Claude Code passes tool details as JSON on stdin.
#
# Exit codes:
#   0  — allow the command (stdout JSON can modify behavior)
#   2  — BLOCK the command (stderr message shown to user)
#   *  — non-blocking warning (shown in verbose mode)
#
# Input JSON fields: session_id, cwd, hook_event_name, tool_name, tool_input
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# Read the JSON input from Claude Code
INPUT=$(cat)

# Extract the bash command being run
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# ── Dangerous command patterns ────────────────────────────────────────────────
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "dd if=/dev/zero"
  "mkfs\."
  "> /dev/sd"
  "chmod -R 777 /"
  ":(){:|:&};:"         # Fork bomb
  "curl.*| *sh"         # Curl-pipe-bash
  "wget.*-O.*| *sh"
)

for PATTERN in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$PATTERN"; then
    echo "Blocked: dangerous command pattern detected: $PATTERN" >&2
    exit 2
  fi
done

# ── Production guard ──────────────────────────────────────────────────────────
# Block destructive commands against production databases
if echo "$COMMAND" | grep -qiE "DROP (TABLE|DATABASE|SCHEMA)|TRUNCATE" ; then
  if echo "$COMMAND" | grep -qi "prod\|production"; then
    echo "Blocked: destructive SQL against production database" >&2
    exit 2
  fi
fi

# ── Allow everything else ─────────────────────────────────────────────────────
exit 0
