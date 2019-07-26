defmodule MyAppWeb.Services.Auth do
  alias Comeonin.Bcrypt
  alias MyApp.Accounts

  def verify_account(email, password) do
    case Accounts.get_user_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        validate_password(user, password)
    end
  end

  def validate_password(%{password: password} = user, password_input) do
    if Bcrypt.checkpw(password_input, password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
end
