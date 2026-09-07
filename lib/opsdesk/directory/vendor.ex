defmodule Opsdesk.Directory.Vendor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vendors" do
    field :name, :string
    field :contact_email, :string
    field :contact_phone, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vendor, attrs) do
    vendor
    |> cast(attrs, [:name, :contact_email, :contact_phone])
    |> validate_required([:name])
    |> validate_length(:name, max: 100)
    |> validate_format(:contact_email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
      message: "must be a valid email"
    )
  end
end
