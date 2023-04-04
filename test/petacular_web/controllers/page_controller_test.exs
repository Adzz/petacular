defmodule PetacularWeb.PageControllerTest do
  use PetacularWeb.ConnCase

  test "GET /", %{conn: conn} do
    _conn = get(conn, ~p"/")
    # assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end
end
