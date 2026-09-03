defmodule Opsdesk.Assets.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsdesk.Assets.CustomField

  schema "categories" do
    field :name, :string
    field :slug, :string

    has_many :custom_fields, CustomField, preload_order: [asc: :position]
    timestamps(type: :utc_datetime)
  end

  @doc """
  Validates a category and derives `slug` from `name` when none is given.
  """
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name])
    |> validate_length(:name, max: 100)
    |> maybe_put_slug()
    |> validate_required([:slug])
    |> unique_constraint(:slug)
  end

  defp maybe_put_slug(changeset) do
    name = get_field(changeset, :name)
    slug = get_field(changeset, :slug)

    cond do
      is_binary(slug) and slug != "" -> changeset
      is_binary(name) -> put_change(changeset, :slug, slugify(name))
      true -> changeset
    end
  end

  defp slugify(name) do
    name
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/u, "")
    |> String.trim()
    |> String.replace(~r/[\s-]+/, "-")
  end
end
