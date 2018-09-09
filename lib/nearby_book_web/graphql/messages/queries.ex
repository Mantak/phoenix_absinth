defmodule NearbyBookWeb.Graphql.Messages.Queries do
  use Absinthe.Schema.Notation

  alias NearbyBook.Messages

  object :messages_queries do
    @desc "获取用户私信"
    field :user_messages, :message_list do
      arg(:user_id, non_null(:id))
      arg(:page_number, :integer, default_value: 0)
      arg(:keywords, :string)

      resolve(fn args, _ ->
        {:ok, Messages.user_messages(args[:user_id], args[:page_number], args[:keywords])}
      end)
    end
  end
end
