defmodule Opsdesk.Directory.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :name, :string

    belongs_to :parent, __MODULE__
    has_many :children, __MODULE__, foreign_key: :parent_id

    timestamps(type: :utc_datetime)
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :parent_id])
    |> validate_required([:name])
    |> validate_length(:name, max: 100)
    |> validate_not_self_parent()
    |> assoc_constraint(:parent)
  end

  defp validate_not_self_parent(changeset) do
    id = get_field(changeset, :id)
    parent_id = get_field(changeset, :parent_id)

    if not is_nil(id) and id == parent_id do
      add_error(changeset, :parent_id, "cannot be its own parent")
    else
      changeset
    end
  end
end
