defmodule Opsdesk.DirectoryTest do
  use Opsdesk.DataCase

  alias Opsdesk.Directory

  describe "departments" do
    alias Opsdesk.Directory.Department

    import Opsdesk.DirectoryFixtures

    @invalid_attrs %{name: nil}

    test "list_departments/0 returns all departments" do
      department = department_fixture()
      assert Directory.list_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert Directory.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Department{} = department} = Directory.create_department(valid_attrs)
      assert department.name == "some name"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Department{} = department} =
               Directory.update_department(department, update_attrs)

      assert department.name == "some updated name"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_department(department, @invalid_attrs)
      assert department == Directory.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Directory.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Directory.change_department(department)
    end
  end

  describe "vendors" do
    alias Opsdesk.Directory.Vendor

    import Opsdesk.DirectoryFixtures

    @invalid_attrs %{name: nil, contact_email: nil, contact_phone: nil}

    test "list_vendors/0 returns all vendors" do
      vendor = vendor_fixture()
      assert Directory.list_vendors() == [vendor]
    end

    test "get_vendor!/1 returns the vendor with given id" do
      vendor = vendor_fixture()
      assert Directory.get_vendor!(vendor.id) == vendor
    end

    test "create_vendor/1 with valid data creates a vendor" do
      valid_attrs = %{
        name: "some name",
        contact_email: "contact@example.com",
        contact_phone: "some contact_phone"
      }

      assert {:ok, %Vendor{} = vendor} = Directory.create_vendor(valid_attrs)
      assert vendor.name == "some name"
      assert vendor.contact_email == "contact@example.com"
      assert vendor.contact_phone == "some contact_phone"
    end

    test "create_vendor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_vendor(@invalid_attrs)
    end

    test "update_vendor/2 with valid data updates the vendor" do
      vendor = vendor_fixture()

      update_attrs = %{
        name: "some updated name",
        contact_email: "updated@example.com",
        contact_phone: "some updated contact_phone"
      }

      assert {:ok, %Vendor{} = vendor} = Directory.update_vendor(vendor, update_attrs)
      assert vendor.name == "some updated name"
      assert vendor.contact_email == "updated@example.com"
      assert vendor.contact_phone == "some updated contact_phone"
    end

    test "update_vendor/2 with invalid data returns error changeset" do
      vendor = vendor_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_vendor(vendor, @invalid_attrs)
      assert vendor == Directory.get_vendor!(vendor.id)
    end

    test "delete_vendor/1 deletes the vendor" do
      vendor = vendor_fixture()
      assert {:ok, %Vendor{}} = Directory.delete_vendor(vendor)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_vendor!(vendor.id) end
    end

    test "change_vendor/1 returns a vendor changeset" do
      vendor = vendor_fixture()
      assert %Ecto.Changeset{} = Directory.change_vendor(vendor)
    end
  end
end
