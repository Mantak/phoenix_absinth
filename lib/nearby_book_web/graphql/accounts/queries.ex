defmodule NearbyBookWeb.Graphql.Accounts.Queries do
  use Absinthe.Schema.Notation
  alias NearbyBook.Accounts

  object :accounts_queries do
    @desc "获取当前用户"
    field :current_user, :user do
      resolve fn _, %{context: context} ->
        {:ok, context[:current_user]}
      end
    end

    @desc "根据ID获取用户"
    field :user, :user do
      arg :id, non_null(:id)
      resolve fn %{id: id}, _ ->
        {:ok, Accounts.get_user id}
      end
    end
  end
end
