defmodule Opsdesk.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string, null: false
      add :parent_id, references(:locations, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:locations, [:parent_id])
  end
end
