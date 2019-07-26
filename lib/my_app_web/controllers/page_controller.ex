defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  def index(conn, _params) do
    # IO.inspect(conn)
    render(conn, "index.html")
  end
end
