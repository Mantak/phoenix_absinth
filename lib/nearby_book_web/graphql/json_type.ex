defmodule NearbyBookWeb.Graphql.JSONType do
  use Absinthe.Schema.Notation

  @desc """
  定义一个全局的json类型
  """
  # :json是在服务器端用的, JSON是在客户端请求是用的
  scalar :json, name: "JSON" do
    parse(&parse_json/1)
    serialize(&serialize_json/1)
  end

  defp parse_json(%{value: value}) do
    case Poison.decode(value) do
      {:ok, result} -> {:ok, result}
      _ -> :error
    end
  end

  defp serialize_json(value) do
    Poison.encode!(value)
  end
end
