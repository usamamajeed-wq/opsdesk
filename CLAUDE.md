# OpsDesk

Multi-tenant SaaS service desk & asset management platform (Elixir/Phoenix).
Full feature spec: `docs/FEATURES.md`

## What it is (one line)
Each company gets an isolated space: employees raise requests (supplies, hardware, facilities) to the admin/IT team, and the company tracks all its equipment (who has what, storage, repairs).

## Core domain (build order matters)
- **Multi-tenancy** — companies fully walled off; first signup user = company admin. Branches within a company (branch manager sees only their branch). Company groups (one login, combined reports, data still separate). Roles per company: Employee, Admin, HR, Finance, CEO.
- **Requests** — employee raises request → category (office supplies / hardware / facilities / other) → status flow (submitted → in progress → done) → message thread with admin team. Admin side: live queue (LiveView, no refresh), claim/assign/comment/close, response-time targets with overdue reminders, in-app + email notifications.
- **Assets** — inventory of equipment; status: available / assigned / under repair / retired; assign to employees; full per-item history; repairs & downtime tracking.
- **Optional/later**: procurement flow with approvals, automation/reminders (warranty, audits, maintenance), reports & activity log, directory (departments, locations, vendors), email-to-request, Slack/Teams, AI features (help assistant, auto-sorting, suggested fixes, thread summarizer), QR asset stickers, ratings, announcements, bookings, prediction dashboards.

## Stack
- Elixir latest (currently 1.17.3 installed), OTP 27
- Phoenix 1.8.x (LiveView 1.x, Bandit, Tailwind + daisyUI, esbuild bundled — no Node needed)
- PostgreSQL 16 local — role `root`, password `password`, has CREATEDB (set BOTH `config/dev.exs` AND `config/test.exs` to these credentials)
- Repo cloned from user's GitHub (`usamamajeed-wq`); SSH config uses Host aliases (pattern: `github-<name>` in `~/.ssh/config`) — check `git remote -v` for which alias this repo uses

## About the user (IMPORTANT)
- PHP/Laravel developer **learning Elixir/Phoenix** — this project doubles as learning. Explain new concepts as they appear, with Laravel comparisons when helpful (conn vs request/response, contexts vs services, Ecto vs Eloquent, changesets vs FormRequest+$fillable, LiveView vs Livewire).
- Followed Stephen Grider's course (Phoenix 1.2 era) — **always flag old-vs-new syntax**: `<%= @x %>` → `{@x}`, `<%= for/if %>` blocks → `:for`/`:if` attributes, views → `*HTML` modules + function components, models → contexts + schemas, explicit `<Layouts.app flash={@flash}>` wrapping (1.8 has no automatic app layout).
- Prefers doing things by hand first to learn, generators after understanding. Let them type/run commands themselves when they ask for steps; act directly when they say "do it".
- User provides day-end status summaries — when asked, produce "DayEnd Status" with concepts covered as bullet lists, checking git commits and untracked files for the day.

## Conventions
- Contexts plural (`Accounts`), schemas singular nested (`Accounts.User`), controllers thin — never call Repo directly from web layer.
- `lib/opsdesk/` = business logic + queries; `lib/opsdesk_web/` = HTTP/LiveView delivery only.
- Run `mix format` before commits. Commit messages: `opsdesk:<description>`.
- Tests: fixtures in `test/support/fixtures/`, SQL Sandbox isolation; test env compiles whole app first.
- Multi-tenant discipline: every tenant-owned table carries company (tenant) id; every context query must scope by tenant — never trust an id from params without scoping.

## Environment quirks
- Editor has a broken Credo linter plugin that background-compiles, causing stale `recompile` → `:noop` in iex; use `recompile(force: true)` when that happens.
- Hex fetch timeouts happen on this connection: retry with `HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get`.
