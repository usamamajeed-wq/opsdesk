defmodule Opsdesk.Repo.Migrations.CreateVendors do
  use Ecto.Migration

  def change do
    create table(:vendors) do
      add :name, :string, null: false
      add :contact_email, :string
      add :contact_phone, :string

      timestamps(type: :utc_datetime)
    end
  end
end
