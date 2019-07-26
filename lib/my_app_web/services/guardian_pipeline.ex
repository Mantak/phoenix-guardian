defmodule MyAppWeb.Services.GuardianPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :my_app,
    error_handler: MyAppWeb.Services.ErrorHandler,
    module: MyAppWeb.Services.Guardian

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
