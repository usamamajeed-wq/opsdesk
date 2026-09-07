defmodule Opsdesk.Directory do
  @moduledoc """
  The Directory context.
  """

  import Ecto.Query, warn: false
  alias Opsdesk.Repo

  alias Opsdesk.Directory.Department
  alias Opsdesk.Directory.Location

  @doc """
  Returns the list of departments.

  ## Examples

      iex> list_departments()
      [%Department{}, ...]

  """
  def list_departments do
    Repo.all(Department)
  end

  @doc """
  Gets a single department.

  Raises `Ecto.NoResultsError` if the Department does not exist.

  ## Examples

      iex> get_department!(123)
      %Department{}

      iex> get_department!(456)
      ** (Ecto.NoResultsError)

  """
  def get_department!(id), do: Repo.get!(Department, id)

  @doc """
  Creates a department.

  ## Examples

      iex> create_department(%{field: value})
      {:ok, %Department{}}

      iex> create_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_department(attrs) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Department{} = department, attrs) do
    department
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a department.

  ## Examples

      iex> delete_department(department)
      {:ok, %Department{}}

      iex> delete_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def delete_department(%Department{} = department) do
    Repo.delete(department)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking department changes.

  ## Examples

      iex> change_department(department)
      %Ecto.Changeset{data: %Department{}}

  """
  def change_department(%Department{} = department, attrs \\ %{}) do
    Department.changeset(department, attrs)
  end

  alias Opsdesk.Directory.Vendor

  @doc """
  Returns the list of vendors.

  ## Examples

      iex> list_vendors()
      [%Vendor{}, ...]

  """
  def list_vendors do
    Repo.all(Vendor)
  end

  @doc """
  Gets a single vendor.

  Raises `Ecto.NoResultsError` if the Vendor does not exist.

  ## Examples

      iex> get_vendor!(123)
      %Vendor{}

      iex> get_vendor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vendor!(id), do: Repo.get!(Vendor, id)

  @doc """
  Creates a vendor.

  ## Examples

      iex> create_vendor(%{field: value})
      {:ok, %Vendor{}}

      iex> create_vendor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vendor(attrs) do
    %Vendor{}
    |> Vendor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vendor.

  ## Examples

      iex> update_vendor(vendor, %{field: new_value})
      {:ok, %Vendor{}}

      iex> update_vendor(vendor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vendor(%Vendor{} = vendor, attrs) do
    vendor
    |> Vendor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vendor.

  ## Examples

      iex> delete_vendor(vendor)
      {:ok, %Vendor{}}

      iex> delete_vendor(vendor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vendor(%Vendor{} = vendor) do
    Repo.delete(vendor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vendor changes.

  ## Examples

      iex> change_vendor(vendor)
      %Ecto.Changeset{data: %Vendor{}}

  """
  def change_vendor(%Vendor{} = vendor, attrs \\ %{}) do
    Vendor.changeset(vendor, attrs)
  end

  def list_locations do
    Location
    |> order_by(asc: :name)
    |> Repo.all()
  end

  def list_root_locations do
    Location
    |> where([l], is_nil(l.parent_id))
    |> order_by(asc: :name)
    |> preload(:children)
    |> Repo.all()
  end

  def get_location!(id), do: Repo.get!(Location, id)

  def create_location(attrs) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  @doc """
  Returns the chain of locations from the root down to the given one.

      location_path(room_302)
      #=> [%Location{name: "HQ"}, %Location{name: "3rd Floor"}, %Location{name: "Room 302"}]
  """
  def location_path(%Location{} = location), do: build_path(location, [location])

  defp build_path(%Location{parent_id: nil}, acc), do: acc

  defp build_path(%Location{parent_id: parent_id}, acc) do
    parent = Repo.get!(Location, parent_id)
    build_path(parent, [parent | acc])
  end

  @doc """
  Renders a location's full path as a breadcrumb string.

      location_breadcrumb(room_302)
      #=> "HQ › 3rd Floor › Room 302"
  """
  def location_breadcrumb(%Location{} = location, separator \\ " › ") do
    location
    |> location_path()
    |> Enum.map_join(separator, & &1.name)
  end
end
