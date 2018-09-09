defmodule NearbyBookWeb.Graphql.Accounts.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: NearbyBook.Repo

  @desc "完整的用户信息"
  object :user do
    field :id, :id
    field :email, :string
    field :nick_name, :string
    field :avatar_url, :string
    field :bio, :string
    field :location, list_of(:float)
    field :token, :string do
      resolve fn (user, _, _) ->
        {:ok, user.access_token}
      end
    end
    field :books_count, :integer do
      resolve fn (user, _, _) ->
        {:ok, Accounts.get_books_count(user)}
      end
    end
  end

  @desc "基本用户信息，比如要获取点赞的朋友的基本信息等"
  object :user_info do
    field :id, :id
    field :email, :string
    field :nick_name, :string
    field :avatar_url, :string
    field :location, list_of(:float)
  end

  @desc "token to authenticate user"
  object :session do
    field :token, :string
  end
end
