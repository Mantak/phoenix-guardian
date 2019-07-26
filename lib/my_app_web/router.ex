defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(MyAppWeb.Services.GuardianPipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :ensure_owner do
    # TODO 只有登录用户就是本人才可以操作
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", MyAppWeb do
    pipe_through([:browser, :auth])

    get("/", PageController, :index)

    get("/users", UserController, :index)
    get("/users/:id", UserController, :show)
    # 注册页面
    get("/signup", UserController, :new)
    # 注册
    post("/create", UserController, :create)
    # 登录页面
    get("/signin", UserController, :sign_in)
    # 登录
    post("/register", UserController, :register)
  end

  scope "/", MyAppWeb do
    pipe_through([:browser, :auth, :ensure_auth])
    get("/dashboard", UserController, :dashboard)
  end

  scope "/", MyAppWeb do
    pipe_through([:browser, :auth, :ensure_auth, :ensure_owner])
    get("/users/:id/edit", UserController, :edit)
    patch("/users/:id", UserController, :update)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)
    get("/signout", UserController, :sign_out)
  end
end
