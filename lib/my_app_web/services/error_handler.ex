defmodule MyAppWeb.Services.ErrorHandler do
  # import Plug.Conn
  import Phoenix.Controller
  alias MyAppWeb.Router.Helpers, as: Routes

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    body = to_string(type)

    conn
    |> put_flash(:error, body <> reason <> "请重新登录")
    |> redirect(to: Routes.user_path(conn, :sign_in))
  end
end
