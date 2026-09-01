# OpsDesk

Multi-tenant SaaS service desk & asset management platform.

Each company gets an isolated space: employees raise requests (office supplies,
hardware, facilities) to the admin/IT team, and the company tracks all its
equipment — who has what, what's in storage, what needs repair.

Full feature spec: [`docs/FEATURES.md`](docs/FEATURES.md)

## Stack

| Component | Version |
| --- | --- |
| Elixir | ~> 1.17 (OTP 27) |
| Phoenix | ~> 1.8.9 |
| Phoenix LiveView | ~> 1.2 |
| Ecto SQL / Postgrex | ~> 3.13 |
| PostgreSQL | 16 |
| Assets | Tailwind + daisyUI via esbuild (no Node required) |

## Prerequisites

- Elixir 1.17+ and OTP 27
- PostgreSQL 16 running locally

The app expects a Postgres role `root` with password `password` and the
`CREATEDB` privilege. To create it:

```bash
sudo -u postgres psql -c "CREATE ROLE root WITH LOGIN PASSWORD 'password' CREATEDB;"
```

If you use different credentials, update **both** `config/dev.exs` and
`config/test.exs` — they must match, or the test suite will fail to connect.

## Setup

```bash
git clone git@github.com:usamamajeed-wq/opsdesk.git
cd opsdesk
mix setup
```

`mix setup` is an alias defined in `mix.exs`. It runs, in order:

1. `deps.get` — fetch Hex dependencies
2. `ecto.setup` — `ecto.create`, then `ecto.migrate`, then seeds
3. `assets.setup` — install the Tailwind and esbuild binaries
4. `assets.build` — compile and bundle CSS/JS

Databases created: `opsdesk_dev` for development, `opsdesk_test` for tests.
They are kept separate because the test suite drops and recreates its database
on every run.

## Running

```bash
mix phx.server
```

Then open [`localhost:4000`](http://localhost:4000).

To run with an interactive shell attached:

```bash
iex -S mix phx.server
```

## Tests

```bash
mix test
```

The `test` alias creates and migrates the test database first, so it works from
a clean checkout. Tests use the Ecto SQL Sandbox, so each test runs in its own
transaction and rolls back — they are isolated and safe to run concurrently.

## Before committing

```bash
mix precommit
```

This alias runs `compile --warnings-as-errors`, `deps.unlock --unused`,
`format`, and `test`. Commit messages follow the pattern `opsdesk:<description>`.

## Layout

The base layout lives in `lib/opsdesk_web/components/layouts.ex`, in the `app/1`
function component — header nav, footer, and theme toggle (system / light / dark).

Phoenix 1.8 does **not** apply the app layout automatically. Only the root
layout is automatic (via `put_root_layout` in `router.ex`). Every page and
LiveView must wrap its own content explicitly:

```heex
<Layouts.app flash={@flash}>
  <h1>Content</h1>
</Layouts.app>
```

The header nav is driven by the `nav_links` attribute, a list of
`{label, path}` tuples, so different roles can be given different navigation
without editing the layout.

## Project structure

- `lib/opsdesk/` — business logic: contexts, schemas, queries
- `lib/opsdesk_web/` — HTTP and LiveView delivery only
- `test/support/fixtures/` — test fixtures
- `docs/FEATURES.md` — full feature spec

Contexts are named in the plural (`Accounts`) with singular nested schemas
(`Accounts.User`). Controllers stay thin and never call `Repo` directly.

Every tenant-owned table carries a company id, and every context query scopes by
tenant. Never trust an id from params without scoping it to the current company.

## Troubleshooting

**Hex fetch timeouts** — retry with reduced concurrency:

```bash
HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get
```

**`ecto.create` fails with a role or authentication error** — the credentials in
`config/dev.exs` don't match your Postgres role. Verify with `psql -U root -h localhost -l`.

**Stale modules in IEx** — if `recompile` returns `:noop` when it shouldn't,
use `recompile(force: true)`.
