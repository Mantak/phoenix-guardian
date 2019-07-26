defmodule MyAppWeb.Plugs.CurrentUser do
  alias MyAppWeb.Services.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    cond do
      user = conn.assigns[:current_user] ->
        assign(conn, :current_user, user)
      user = Guardian.Plug.current_resource(conn) ->
        assign(conn, :current_user, user)
      true ->
        conn
    end
  end
end
