defmodule OpsdeskWeb.PageController do
  use OpsdeskWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
