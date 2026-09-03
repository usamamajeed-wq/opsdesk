defmodule OpsdeskWeb.CategoryLive.Form do
  use OpsdeskWeb, :live_view

  alias Opsdesk.Assets
  alias Opsdesk.Assets.Category

  @impl true
  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    category = %Category{}

    socket
    |> assign(:page_title, "New Category")
    |> assign(:category, category)
    |> assign(:form, to_form(Assets.change_category(category)))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    category = Assets.get_category!(id)

    socket
    |> assign(:page_title, "Edit Category")
    |> assign(:category, category)
    |> assign(:form, to_form(Assets.change_category(category)))
  end

  @impl true
  def handle_event("validate", %{"category" => params}, socket) do
    changeset = Assets.change_category(socket.assigns.category, params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"category" => params}, socket) do
    save_category(socket, socket.assigns.live_action, params)
  end

  defp save_category(socket, :new, params) do
    case Assets.create_category(params) do
      {:ok, category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category created.")
         |> push_navigate(to: ~p"/admin/categories/#{category}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_category(socket, :edit, params) do
    case Assets.update_category(socket.assigns.category, params) do
      {:ok, category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category updated.")
         |> push_navigate(to: ~p"/admin/categories/#{category}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
