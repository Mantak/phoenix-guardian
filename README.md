# MyApp

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


### 新建项目，使用字符串id，创建项目时，指定了binary-id，以后gen.xx的时候，自动使用binary-id
mix phx.new my_app --binary-id
### mix.exs里新增几个包
      # 登录插件
      {:guardian, "~> 1.0"},
      # 密码加密
      {:comeonin, "~> 4.0"},
      # comeonin用到的包
      {:bcrypt_elixir, "~> 0.12"}

### 新建html
mix phx.gen.html Accounts.User users email:string  password:string
### 修改/priv/repo/create_users.exs 新增index
create(unique_index(:users, [:email]))
### 修改/lib/accounts.ex 增加get_user和使用email登录
def get_user(id), do: Repo.get(User, id)
def get_user_by_email(email), do: Repo.get_by(User, email: email)
### 修改 lib/my_app/accounts/user.ex 的 changeset
 添加|> hash_password() 使得创建的时候，自动保存加密过的密码
### 修改路由配置
### 新建/_web/services 放(登录)相关服务
  auth.ex
  error_handler.ex
  guardian.ex
  guardian_pipeline.ex
### config.exs里添加guardian的配置
### Guardian Config
config :my_app, AuthAppWeb.Services.Guardian,
  issuer: "my_app",
  secret_key: "xxx"
