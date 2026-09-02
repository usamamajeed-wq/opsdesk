defmodule Opsdesk.Repo.Migrations.CreateCategoriesAndCustomFields do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :slug, :string, null: false

      timestamps(type: :utc_datetime)
    end
    create unique_index(:categories, [:slug])

    create table(:custom_fields) do
      add :category_id, references(:categories, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :field_type, :string, null: false
      add :required, :boolean, null: false, default: false
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:custom_fields, [:category_id])
    create unique_index(:custom_fields, [:category_id, :name])

  end
end
