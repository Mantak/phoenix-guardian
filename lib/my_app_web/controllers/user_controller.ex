defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller
  alias MyAppWeb.Services.{Auth, Guardian}

  alias MyApp.Accounts
  alias MyApp.Accounts.User

  def index(conn, _params) do
    # token = Guardian.Plug.current_token(conn)
    # {:ok, resource, _claims} = Guardian.resource_from_token(token)
    # IO.inspect(resource)
    # IO.puts(resource.inserted_at)
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.user_path(conn, :dashboard))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def sign_in(conn, _params) do
    if Guardian.Plug.current_resource(conn) do
      redirect(conn, to: Routes.user_path(conn, :dashboard))
    else
      changeset = Accounts.change_user(%User{})
      render(conn, "sign_in.html", changeset: changeset)
    end
  end

  def register(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Auth.verify_account(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "账号或密码错误")
        |> sign_in(%{})
    end
  end

  def sign_out(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def dashboard(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "dashboard.html", user: user)
  end
end
