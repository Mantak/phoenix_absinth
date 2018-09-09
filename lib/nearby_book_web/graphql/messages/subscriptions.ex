defmodule NearbyBookWeb.Graphql.Messages.Subscriptions do
  # This module contains macros used to build GraphQL types.
  # 凡是定义graphql类型，都需要这个宏
  use Absinthe.Schema.Notation

  alias NearbyBook.Messages.Message

  object :messages_subscriptions do
    @desc "每个用户都订阅发给自己的私信"
    field :fresh_message, :message do
      arg(:user_id, non_null(:id))

      config(fn args, _ ->
        {:ok, topic: args[:user_id]}
      end)

      # 当create_message发生的时候，如果topic函数返回的值的topic和config的topic匹配的话，则发布到订阅
      # 这样当客户端订阅:fresh_message的时候，会获得到合适的数据
      trigger(
        :create_message,
        topic: fn
          # 这里的message是个query对象，所以不能用message[:receiver_id]来调用，否则出错
          %Message{} = message ->
            message.receiver_id

          _ ->
            []
        end
      )
    end
  end
end
