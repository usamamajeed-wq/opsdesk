defmodule Opsdesk.Repo do
  use Ecto.Repo,
    otp_app: :opsdesk,
    adapter: Ecto.Adapters.Postgres
end
