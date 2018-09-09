# NearbyBook

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## 创建项目，脚手架使用uuid，不需要html页面，也不需要js文件
```
  mix phx.new api_server --binary-id --no-html --no-brunch
```
## 添加必要的包,如果提示Web.Endpoint.HTTP (cowboy_protocol) terminated，删除_build包，重新编译即可
```
  /mix.exs
```
## 添加context，让每次访问都走该plug，来处理用户身份验证
```
  /lib/nearby_book_web/context.ex
```
## 添加schema
```
  /lib/nearby_book_web/schema.ex
```
## 配置路由
```
/lib/nearby_book_web/routes.ex
```
## 配置 /lib/nearby_book_web/channels/user_socket.ex， 更改内容如下：
```
  use Absinthe.Phoenix.Socket, schema: NearbyBookWeb.Schema
  def connect(_params, socket) do
    {:ok, assign(socket, :absinthe, %{schema: NearbyBookWeb.Schema})}
  end
```
## 配置 /lib/nearby_book/application.ex， 挂载pubsub
```
    supervisor(Absinthe.Subscription, [NearbyBookWeb.Endpoint])
```
## 配置/lib/nearby_book_web/endpoint.ex，添加内容如下：
```
  use Absinthe.Phoenix.Endpoint

  if Mix.env() == :dev do
    plug(CORSPlug, origin: "http://localhost:3000")
  end

```
## 配置/lib/nearby_book/repo.ex，挂载分页功能：
```
  use Scrivener, page_size: 10
```
