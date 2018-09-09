import NearbyBookWeb.Helpers.ValidationMessageHelpers

defmodule NearbyBookWeb.Middleware.Authorize do
  @behaviour Absinthe.Middleware
  alias NearbyBook.Accounts.User

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: %User{}} -> resolution
      _ ->
        message = "该类操作，需要身份验证，请先登陆"
        resolution |> Absinthe.Resolution.put_result({:ok, generic_message(message)})
    end
  end
end
