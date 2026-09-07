defmodule Opsdesk.DirectoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Opsdesk.Directory` context.
  """

  @doc """
  Generate a department.
  """
  def department_fixture(attrs \\ %{}) do
    {:ok, department} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Opsdesk.Directory.create_department()

    department
  end

  @doc """
  Generate a vendor.
  """
  def vendor_fixture(attrs \\ %{}) do
    {:ok, vendor} =
      attrs
      |> Enum.into(%{
        contact_email: "contact@example.com",
        contact_phone: "some contact_phone",
        name: "some name"
      })
      |> Opsdesk.Directory.create_vendor()

    vendor
  end
end
