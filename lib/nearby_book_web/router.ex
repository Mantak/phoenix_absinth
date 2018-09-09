defmodule NearbyBookWeb.Router do
  use NearbyBookWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(NearbyBookWeb.Plugs.Context)
  end

  # scope "/api", NearbyBookWeb do
  # pipe_through :api
  # end
  scope "/" do
    pipe_through(:api)
    forward("/graphql", Absinthe.Plug, schema: NearbyBookWeb.Schema)
    # 如果是开发环境，额外增加一个/graphiql路由
    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL,
        schema: NearbyBookWeb.Schema,
        socket: NearbyBookWeb.UserSocket
      )
    end
  end
end
