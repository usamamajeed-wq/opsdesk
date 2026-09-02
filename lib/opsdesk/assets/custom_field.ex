defmodule Opsdesk.Assets.CustomField do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsdesk.Assets.Category

  @field_types [:string, :integer, :boolean, :date, :select]

  schema "custom_fields" do
      field :name, :string
      field :field_type, Ecto.Enum, values: @field_types
      field :required, :boolean, default: false
      field :position, :integer, default: 0

      belongs_to :category, Category

      timestamps(type: :utc_datetime)
  end

 @doc "The field types a custom field may take."
    def field_types, do: @field_types

    def changeset(custom_field, attrs) do
      custom_field
      |> cast(attrs, [:name, :field_type, :required, :position, :category_id])
      |> validate_required([:name, :field_type, :category_id])
      |> validate_length(:name, max: 100)
      |> assoc_constraint(:category)
      |> unique_constraint([:category_id, :name],
        name: :custom_fields_category_id_name_index,
        message: "already exists for this category"
      )
    end

end
