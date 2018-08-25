defmodule WlpWeb.PageController do
  use WlpWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
