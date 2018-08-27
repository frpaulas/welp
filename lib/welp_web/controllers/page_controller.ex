defmodule WelpWeb.PageController do
  use WelpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
