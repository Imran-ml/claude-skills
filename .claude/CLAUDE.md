# Project Instructions

This file is automatically loaded by Claude Code at session start.
Place project-specific instructions, conventions, and context here.

---

## Project Overview

Describe your project here. What does it do? Who uses it?

## Tech Stack

- **Language:** TypeScript / Node.js
- **Framework:** (e.g., Next.js, Express, NestJS)
- **Database:** (e.g., PostgreSQL with Prisma)
- **Testing:** (e.g., Jest + Playwright)
- **CI/CD:** (e.g., GitHub Actions)

## Repository Layout

```
src/
  components/    # React components
  lib/           # Shared utilities
  api/           # API route handlers
  types/         # TypeScript type definitions
tests/
  unit/          # Unit tests
  e2e/           # End-to-end tests
docs/            # Documentation
```

## Code Conventions

- Use `const` over `let` wherever possible
- Prefer functional components over class components
- Always add JSDoc comments to exported functions
- Keep functions under 50 lines; extract helpers when needed
- Use named exports, not default exports
- File names: `kebab-case.ts`

## Testing Rules

- Every new function needs at least one unit test
- Run `npm test` before committing
- Do NOT mock the database in integration tests — use a real test DB
- E2E tests live in `tests/e2e/`

## Git Conventions

- Commit style: Conventional Commits (`feat:`, `fix:`, `docs:`, etc.)
- Branch names: `feat/short-description` or `fix/issue-number`
- Never force-push to `main` or `develop`
- PRs require at least 1 reviewer approval

## Important Rules

- Never modify files in `generated/` directly — they are auto-generated
- Always use environment variables for secrets; never hardcode them
- Check `CHANGELOG.md` before making breaking changes
- Run `npm run lint` before submitting any PR

## Preferred Workflow

1. Read relevant files before suggesting changes
2. Write tests before or alongside implementation
3. Keep changes focused; one concern per PR
4. Update docs when adding public-facing features
