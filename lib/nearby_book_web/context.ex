# 一个plug模块，必须有两个函数，一是init，一是call，init处理参数
# call 第一个参数是链接，第二个是opitons，返回conn
# https://hexdocs.pm/plug/Plug.html#c:call/2
defmodule NearbyBookWeb.Plugs.Context do
  @behaviour Plug
  import Plug.Conn

  alias NearbyBookWeb.Helpers.StringHelpers
  alias NearbyBook.Accounts.User
  alias NearbyBook.Repo

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    # Assigns a new private key and value in the connection.
    # https://hexdocs.pm/plug/Plug.Conn.html#put_private/3
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- StringHelpers.present?(token),
         {:ok, user} <- get_user(token) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp get_user(token) do
    user = User |> Repo.get_by(access_token: token)
    {:ok, user}
  end
end
