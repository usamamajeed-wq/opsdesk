defmodule OpsdeskWeb.PageControllerTest do
  use OpsdeskWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    response = html_response(conn, 200)

    assert response =~ "Multi-tenant service desk"
    assert response =~ "OpsDesk"
  end
end
