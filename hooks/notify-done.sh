#!/usr/bin/env bash
# ─── Notify Done Hook ───────────────────────────────────────────────────────
#
# Runs when Claude finishes responding (Stop event).
# Sends a desktop notification so you know Claude is done.
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

INPUT=$(cat)
MESSAGE="Claude has finished responding"

# ── macOS ─────────────────────────────────────────────────────────────────────
if command -v osascript &>/dev/null; then
  osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\""
  exit 0
fi

# ── Linux (libnotify) ─────────────────────────────────────────────────────────
if command -v notify-send &>/dev/null; then
  notify-send "Claude Code" "$MESSAGE" --icon=dialog-information
  exit 0
fi

# ── Windows (PowerShell) ──────────────────────────────────────────────────────
if command -v powershell.exe &>/dev/null; then
  powershell.exe -Command "
    Add-Type -AssemblyName System.Windows.Forms
    \$notify = New-Object System.Windows.Forms.NotifyIcon
    \$notify.Icon = [System.Drawing.SystemIcons]::Information
    \$notify.Visible = \$true
    \$notify.ShowBalloonTip(3000, 'Claude Code', '$MESSAGE', [System.Windows.Forms.ToolTipIcon]::Info)
  "
  exit 0
fi

# Fallback: just print to terminal
echo "✓ $MESSAGE"
exit 0
