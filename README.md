# Claude Code Configuration Repository

A comprehensive, ready-to-use `.claude` configuration repository covering **Skills**, **Subagents**, **MCP Servers**, **Hooks**, **Keybindings**, and **Settings**  everything you need to supercharge Claude Code.

---

## Table of Contents

- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Settings](#settings)
- [CLAUDE.md](#claudemd)
- [Skills (Slash Commands)](#skills-slash-commands)
- [Subagents](#subagents)
- [MCP Servers](#mcp-servers)
- [Hooks](#hooks)
- [Keybindings](#keybindings)
- [Memory System](#memory-system)
- [Configuration Scopes](#configuration-scopes)

---

## Repository Structure

```
.
├── README.md
├── .gitignore
├── .mcp.json                          # MCP server configurations (project-level)
│
├── .claude/
│   ├── CLAUDE.md                      # Project instructions for Claude
│   ├── settings.json                  # Project-level settings
│   ├── settings.local.json            # Local overrides (gitignored)
│   │
│   ├── skills/                        # Custom slash commands
│   │   ├── commit/SKILL.md            # /commit — smart git commits
│   │   ├── review-pr/SKILL.md         # /review-pr — PR review
│   │   ├── test/SKILL.md              # /test — run & fix tests
│   │   ├── security-audit/SKILL.md    # /security-audit — security scan
│   │   ├── generate-docs/SKILL.md     # /generate-docs — write docs
│   │   └── deploy/SKILL.md            # /deploy — deployment helper
│   │
│   └── agents/                        # Custom subagents
│       ├── code-reviewer.md           # Deep code review specialist
│       ├── test-generator.md          # Test writing specialist
│       ├── security-auditor.md        # Security analysis specialist
│       └── doc-writer.md              # Documentation specialist
│
├── hooks/                             # Hook scripts
│   ├── pre-tool-use.sh
│   ├── post-tool-use.sh
│   └── session-start.sh
│
└── examples/
    ├── user-settings.json             # ~/.claude/settings.json example
    ├── keybindings.json               # ~/.claude/keybindings.json example
    └── managed-mcp.json               # Enterprise managed MCP example
```

---

## Quick Start

### 1. Clone this repo into your project

```bash
git clone https://github.com/your-username/claude-config .claude-config
cp -r .claude-config/.claude .
cp .claude-config/.mcp.json .
```

### 2. Or use as a template

Click **"Use this template"** on GitHub to create your own copy.

### 3. Install for a single project

```bash
# Copy settings
cp examples/user-settings.json ~/.claude/settings.json

# Copy keybindings
cp examples/keybindings.json ~/.claude/keybindings.json
```

---

## Settings

### Configuration Scopes (Priority Order)

| Scope | File | Shared | Priority |
|-------|------|--------|----------|
| **Managed** | System dirs (see below) | Yes | Highest |
| **User** | `~/.claude/settings.json` | No | 2nd |
| **Project** | `.claude/settings.json` | Yes (git) | 3rd |
| **Local** | `.claude/settings.local.json` | No | Lowest |

**Managed settings file locations:**
- macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`
- Linux: `/etc/claude-code/managed-settings.json`
- Windows: `C:\Program Files\ClaudeCode\managed-settings.json`

### Key Settings Options

```jsonc
{
  // API Configuration
  "apiBaseUrl": "https://api.anthropic.com",
  "model": "claude-opus-4-6",

  // Permission mode: "default" | "acceptEdits" | "autoEdit" | "bypassPermissions"
  "permissionMode": "default",

  // Tool permissions
  "allowedTools": ["Read", "Glob", "Grep"],
  "deniedTools": ["Bash"],

  // Disable non-essential features for performance
  "disableAutoUpdates": false,
  "disableTelemetry": false,

  // Environment variables passed to Claude
  "env": {
    "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}",
    "MAX_MCP_OUTPUT_TOKENS": "25000"
  },

  // Hooks configuration (see Hooks section)
  "hooks": {},

  // MCP tool search (auto-enabled when tools > 10% context)
  "enableMcpToolSearch": true
}
```

See [`.claude/settings.json`](.claude/settings.json) for the full working example.

---

## CLAUDE.md

`CLAUDE.md` is loaded at session start and provides persistent instructions to Claude. Place it at:

- `~/.claude/CLAUDE.md` — applies to all projects (user-level)
- `.claude/CLAUDE.md` — applies to this project only
- Any parent directory — applies to all subdirectories

### What to put in CLAUDE.md

```markdown
# Project Instructions

## Tech Stack
- Language: TypeScript / Node.js
- Framework: Next.js 14
- Database: PostgreSQL with Prisma ORM
- Testing: Jest + Playwright

## Code Conventions
- Use `const` over `let` where possible
- Always add JSDoc to exported functions
- Run `npm test` before committing

## Important Rules
- Never modify files in `generated/` directly
- Always use environment variables for secrets
- Prefer functional components over class components
```

See [`.claude/CLAUDE.md`](.claude/CLAUDE.md) for the full example.

---

## Skills (Slash Commands)

Skills live in `.claude/skills/<name>/SKILL.md`. Invoke with `/<name>` in Claude Code.

### SKILL.md Frontmatter Reference

```yaml
---
name: skill-name              # Lowercase, hyphens, max 64 chars
description: |                # Tells Claude WHEN to auto-invoke
  When to use this skill...
argument-hint: "[optional]"   # Shown in autocomplete
disable-model-invocation: false   # true = only user can invoke
user-invocable: true          # false = only Claude can invoke
allowed-tools: "Read, Grep"   # Tools usable without permission
model: claude-haiku-4-5-20251001  # Override model for this skill
context: fork                 # "fork" = run in isolated subagent
agent: Explore                # Built-in agent type to use
---

Skill prompt content here...
```

### String Substitutions

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed to the skill |
| `$ARGUMENTS[0]`, `$0` | First argument |
| `$ARGUMENTS[1]`, `$1` | Second argument |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Path to this skill's directory |

### Dynamic Context (Backtick Injection)

Run shell commands whose output is injected before the prompt:

```markdown
!`git log --oneline -10`

Based on recent commits above, write a changelog entry.
```

### Included Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Smart Commit | `/commit` | Stages, reviews, and commits with conventional message |
| PR Review | `/review-pr [number]` | Full pull request code review |
| Test Runner | `/test [file]` | Run tests and auto-fix failures |
| Security Audit | `/security-audit` | OWASP-based security scan |
| Generate Docs | `/generate-docs [path]` | Create/update documentation |
| Deploy | `/deploy [env]` | Deployment checklist and execution |

---

## Subagents

Custom subagents live in `.claude/agents/<name>.md`. Claude automatically delegates tasks to them based on their `description`.

### Agent Frontmatter Reference

```yaml
---
name: agent-name              # Identifier used in Agent tool calls
description: |                # CRITICAL: tells Claude when to delegate
  Use this agent when...      # Be specific about trigger conditions
tools:                        # Comma-separated or array of allowed tools
  - Read
  - Grep
  - Glob
  - Bash
model: claude-haiku-4-5-20251001  # Optional: use cheaper model
---

System prompt for the agent...
```

### Built-in Subagents

| Agent | Description |
|-------|-------------|
| `general-purpose` | Default agent for complex multi-step tasks |
| `Explore` | Fast codebase exploration (search, read, grep) |
| `Plan` | Architecture and implementation planning |

### Included Custom Agents

| Agent | File | Specialization |
|-------|------|----------------|
| Code Reviewer | `agents/code-reviewer.md` | Deep code quality analysis |
| Test Generator | `agents/test-generator.md` | Writing comprehensive tests |
| Security Auditor | `agents/security-auditor.md` | Security vulnerability scanning |
| Doc Writer | `agents/doc-writer.md` | Technical documentation |

---

## MCP Servers

MCP (Model Context Protocol) connects Claude to external tools. Configured in `.mcp.json` (project-level, shared via git).

### Add a Server

```bash
# HTTP server
claude mcp add --transport http <name> <url>

# Stdio server (local process)
claude mcp add --transport stdio <name> -- <command> [args]

# With environment variables
claude mcp add --transport stdio github -- \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  npx -y @modelcontextprotocol/server-github
```

### MCP Scopes

| Scope | Storage | Shared | Command |
|-------|---------|--------|---------|
| Local | `~/.claude.json` | No | `--scope local` (default) |
| Project | `.mcp.json` | Yes (git) | `--scope project` |
| User | `~/.claude.json` | No | `--scope user` |

**Precedence:** Local > Project > User

### Included MCP Servers (`.mcp.json`)

| Server | Transport | Use Case |
|--------|-----------|----------|
| GitHub | Stdio | Issues, PRs, repos |
| Filesystem | Stdio | File operations |
| Memory | Stdio | Persistent knowledge graph |
| Brave Search | HTTP | Web search |
| PostgreSQL | Stdio | Database queries |
| Slack | HTTP | Team messaging |
| Notion | HTTP | Documentation |

### MCP Commands

```bash
claude mcp list                    # List all servers
claude mcp get <name>              # Server details
claude mcp remove <name>           # Remove server
claude mcp reset-project-choices   # Reset approval state
/mcp                               # Check status in Claude Code
```

---

## Hooks

Hooks run shell commands, HTTP requests, prompts, or agents at lifecycle events.

### Hook Events

| Event | Trigger |
|-------|---------|
| `SessionStart` | Session begins or resumes |
| `UserPromptSubmit` | Before Claude processes your message |
| `PreToolUse` | Before any tool executes |
| `PostToolUse` | After tool succeeds |
| `PostToolUseFailure` | After tool fails |
| `PermissionRequest` | Permission dialog triggered |
| `Stop` | Claude finishes responding |
| `SubagentStart` | Subagent spawned |
| `SubagentStop` | Subagent finishes |
| `Notification` | Notification sent |
| `TaskCompleted` | Task marked complete |
| `PreCompact` | Before context compaction |
| `PostCompact` | After context compaction |
| `SessionEnd` | Session terminates |

### Hook Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/pre-tool-use.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "http",
            "url": "http://localhost:9000/hook",
            "headers": { "Authorization": "Bearer $HOOK_TOKEN" }
          }
        ]
      }
    ]
  }
}
```

### Hook Types

**Command Hook:**
```json
{
  "type": "command",
  "command": "/path/to/script.sh",
  "timeout": 600,
  "async": false,
  "statusMessage": "Validating..."
}
```

**HTTP Hook:**
```json
{
  "type": "http",
  "url": "http://localhost:8080/hooks/event",
  "headers": { "X-Secret": "$HOOK_SECRET" },
  "allowedEnvVars": ["HOOK_SECRET"],
  "timeout": 30
}
```

**Prompt Hook:**
```json
{
  "type": "prompt",
  "prompt": "Review this tool call: $ARGUMENTS",
  "model": "claude-haiku-4-5-20251001",
  "timeout": 30
}
```

**Agent Hook:**
```json
{
  "type": "agent",
  "prompt": "Verify tests pass after this change.",
  "timeout": 60
}
```

### Hook Exit Codes (Command Hooks)

| Code | Meaning |
|------|---------|
| `0` | Success; stdout parsed as JSON response |
| `2` | Blocking error; action is blocked |
| Other | Non-blocking warning; shown in verbose mode |

### MCP Tool Matcher Pattern

```
mcp__<server>__<tool>

Examples:
  mcp__github__.*          # All GitHub tools
  mcp__.*__write.*         # All write tools across servers
  mcp__memory__.*          # All Memory tools
```

See [`.claude/settings.json`](.claude/settings.json) and [`hooks/`](hooks/) for working examples.

---

## Keybindings

Keybindings live at `~/.claude/keybindings.json` (user-level, not project-level).

### File Format

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+u": null
      }
    }
  ]
}
```

### Available Contexts

`Global`, `Chat`, `Autocomplete`, `Settings`, `Confirmation`, `Tabs`, `Help`, `Transcript`, `HistorySearch`, `Task`, `ThemePicker`, `Attachments`, `Footer`, `MessageSelector`, `DiffDialog`, `ModelPicker`, `Select`, `Plugin`

### Key Syntax

```
ctrl+k           # Single modifier
alt+shift+p      # Multiple modifiers
ctrl+k ctrl+s    # Chord (sequence)
escape, enter, tab, space, up, down, left, right
backspace, delete, f1–f12
```

### Common Actions

| Context | Action | Default |
|---------|--------|---------|
| Global | `app:interrupt` | `ctrl+c` |
| Global | `app:exit` | `ctrl+d` |
| Global | `app:toggleTodos` | `ctrl+t` |
| Chat | `chat:submit` | `enter` |
| Chat | `chat:cancel` | `escape` |
| Chat | `chat:externalEditor` | `ctrl+g` |
| Chat | `chat:stash` | `ctrl+s` |
| Autocomplete | `autocomplete:accept` | `tab` |
| Confirmation | `confirm:yes` | `y` / `enter` |
| Confirmation | `confirm:no` | `n` / `escape` |

Set `null` to unbind a key: `"ctrl+u": null`

See [`examples/keybindings.json`](examples/keybindings.json) for a full working example.

---

## Memory System

Claude Code has a built-in memory system at `~/.claude/projects/<project>/memory/`.

### Memory Types

| Type | When to Use |
|------|-------------|
| `user` | User role, preferences, expertise level |
| `feedback` | Corrections and behavioral guidance |
| `project` | Goals, decisions, deadlines |
| `reference` | External system pointers (Jira, Slack, etc.) |

### Memory File Format

```markdown
---
name: memory-name
description: One-line description for relevance matching
type: user | feedback | project | reference
---

Memory content here.

**Why:** Reason this memory exists.
**How to apply:** When/where to use this.
```

---

## Configuration Scopes

```
Priority (highest → lowest):

[Managed]    /etc/claude-code/managed-settings.json
             C:\Program Files\ClaudeCode\managed-settings.json  (Windows)
             /Library/Application Support/ClaudeCode/           (macOS)
     ↓
[User]       ~/.claude/settings.json
     ↓
[Project]    .claude/settings.json
     ↓
[Local]      .claude/settings.local.json   ← never commit this
```

### Gitignore Recommendations

```gitignore
# Always gitignore
.claude/settings.local.json
.env
.env.local

# Optional: gitignore if contains secrets
.mcp.json
```

---

## Resources

- [Claude Code Docs](https://code.claude.com/docs/en)
- [Settings Reference](https://code.claude.com/docs/en/settings)
- [Skills Reference](https://code.claude.com/docs/en/skills)
- [Sub-agents Reference](https://code.claude.com/docs/en/sub-agents)
- [MCP Reference](https://code.claude.com/docs/en/mcp)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Keybindings Reference](https://code.claude.com/docs/en/keybindings)
- [MCP Protocol Spec](https://modelcontextprotocol.io)

---

## Contributing

Contributions are welcome! This repository grows better with community-shared skills, agents, MCP server configs, hooks, and keybinding setups.

### What you can contribute

| Type | Where to add | What makes a good one |
|------|-------------|----------------------|
| **Skill** | `.claude/skills/<name>/SKILL.md` | Clear `description` so Claude knows when to auto-invoke; includes examples |
| **Subagent** | `.claude/agents/<name>.md` | Focused on a specific domain; specifies appropriate `tools` and `model` |
| **MCP Server** | `.mcp.json` | Commented with setup instructions, required env vars, and a link to the server |
| **Hook** | `hooks/<event-name>.sh` | Well-commented, safe exit codes, handles all three OSes |
| **Keybinding preset** | `examples/keybindings/` | Named for the use-case (e.g., `vim-style.json`, `minimal.json`) |
| **Settings preset** | `examples/settings/` | Named for the context (e.g., `enterprise.json`, `open-source.json`) |

### How to contribute

1. **Fork** this repository
2. **Create a branch:** `git checkout -b feat/my-skill-name`
3. **Add your file(s)** following the existing structure and conventions
4. **Test it** — make sure your skill/agent works in Claude Code
5. **Open a Pull Request** with a short description of what it does and when to use it

### Guidelines

- Keep skill and agent `description` fields clear and specific — Claude uses them to decide when to delegate
- Never include real API keys, tokens, or secrets — use `${ENV_VAR}` placeholders
- Add comments explaining non-obvious configuration choices
- One skill or agent per PR keeps reviews focused

---

## About Author

**Name:** Muhammad Imran Zaman
**Email:** imranzaman.ml@gmail.com

**Professional Links:**
- [Kaggle Profile](https://www.kaggle.com/imranzaman)
- [LinkedIn Profile](https://www.linkedin.com/in/muhammad-imran-zaman/)
- [Google Scholar Profile](https://scholar.google.com/citations?user=ImranZaman)
- [YouTube Channel](https://www.youtube.com/channel/UCImranZaman)
- [GitHub Repository](https://github.com/Imran-ml/Mental-Health-Chatbot-LLaMA3.1)
- [Medium Story](https://imranzaman-5202.medium.com/)
