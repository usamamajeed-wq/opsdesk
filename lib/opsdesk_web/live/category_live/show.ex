defmodule OpsdeskWeb.CategoryLive.Show do
  use OpsdeskWeb, :live_view

  alias Opsdesk.Assets
  alias Opsdesk.Assets.CustomField

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:field_types, CustomField.field_types())
     |> load_category(id)
     |> reset_field_form()}
  end

  defp load_category(socket, id) do
    category = Assets.get_category!(id)

    socket
    |> assign(:page_title, category.name)
    |> assign(:category, category)
  end

  defp reset_field_form(socket) do
    socket
    |> assign(:editing, nil)
    |> assign(:field_form, to_form(Assets.change_custom_field(%CustomField{})))
  end

  defp find_field(socket, id) do
    Enum.find(socket.assigns.category.custom_fields, &(&1.id == String.to_integer(id)))
  end

  @impl true
  def handle_event("edit_field", %{"id" => id}, socket) do
    field = find_field(socket, id)

    {:noreply,
     socket
     |> assign(:editing, field)
     |> assign(:field_form, to_form(Assets.change_custom_field(field)))}
  end

  def handle_event("cancel_edit", _params, socket) do
    {:noreply, reset_field_form(socket)}
  end

  def handle_event("validate_field", %{"custom_field" => params}, socket) do
    base = socket.assigns.editing || %CustomField{}
    changeset = Assets.change_custom_field(base, params)
    {:noreply, assign(socket, :field_form, to_form(changeset, action: :validate))}
  end

  def handle_event("save_field", %{"custom_field" => params}, socket) do
    result =
      case socket.assigns.editing do
        nil -> Assets.create_custom_field(socket.assigns.category, params)
        field -> Assets.update_custom_field(field, params)
      end

    case result do
      {:ok, _field} ->
        {:noreply,
         socket
         |> put_flash(:info, "Field saved.")
         |> load_category(socket.assigns.category.id)
         |> reset_field_form()}

      {:error, changeset} ->
        {:noreply, assign(socket, :field_form, to_form(changeset))}
    end
  end

  def handle_event("delete_field", %{"id" => id}, socket) do
    {:ok, _} = socket |> find_field(id) |> Assets.delete_custom_field()

    {:noreply,
     socket
     |> put_flash(:info, "Field deleted.")
     |> load_category(socket.assigns.category.id)
     |> reset_field_form()}
  end
end
