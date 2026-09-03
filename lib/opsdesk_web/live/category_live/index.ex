defmodule OpsdeskWeb.CategoryLive.Index do
  use OpsdeskWeb, :live_view

  alias Opsdesk.Assets

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Categories")
     |> assign(:categories, Assets.list_categories())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Assets.get_category!(id)
    {:ok, _} = Assets.delete_category(category)

    {:noreply,
     socket
     |> put_flash(:info, "Category deleted.")
     |> assign(:categories, Assets.list_categories())}
  end
end
