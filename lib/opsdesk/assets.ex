defmodule Opsdesk.Assets do
  @moduledoc """
   Asset categories and their custom field definitions.
  """
  import Ecto.Query, warn: false

  alias Opsdesk.Repo
  alias Opsdesk.Assets.{Category, CustomField}

  def list_categories do
    Category
    |> order_by(asc: :name)
    |> preload(:custom_fields)
    |> Repo.all()
  end

  def get_category!(id) do
    Category
    |> preload(:custom_fields)
    |> Repo.get!(id)
  end

  def create_category(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category), do: Repo.delete(category)

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  ## Custom fields

  def create_custom_field(%Category{} = category, attrs) do
    attrs = Map.put(attrs, "category_id", category.id)

    %CustomField{}
    |> CustomField.changeset(attrs)
    |> Repo.insert()
  end

  def update_custom_field(%CustomField{} = field, attrs) do
    field
    |> CustomField.changeset(attrs)
    |> Repo.update()
  end

  def delete_custom_field(%CustomField{} = field), do: Repo.delete(field)

  def change_custom_field(%CustomField{} = field, attrs \\ %{}) do
    CustomField.changeset(field, attrs)
  end
end
