defmodule NearbyBookWeb.Graphql.Messages.Mutations do
  use Absinthe.Schema.Notation
  # import Ecto.Query, warn: false

  import Kronky.Payload
  import NearbyBookWeb.Helpers.ValidationMessageHelpers

  alias NearbyBookWeb.Middleware
  alias NearbyBook.Messages

  payload_object(:message_payload, :message)

  object :messages_mutations do
    @desc "生成私信"
    field :create_message, :message_payload do
      arg :input, :message_input
      middleware Middleware.Authorize

      resolve fn (%{input: params}, %{context: context}) ->
        case context[:current_user] |> Messages.create_message(params) do
          {:ok, message} -> {:ok, message}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end
    end

    @desc "更新私信"
    field :update_message, :message_payload do
      arg :id, non_null(:id)
      arg :input, :message_input
      middleware Middleware.Authorize

      resolve fn (%{id: id, input: params}, %{context: context}) ->
        message = Messages.get_message(id)
        with true <- Messages.is_message_author(context[:current_user], message),
          {:ok, messageMulti} <- Messages.update_message(message, params)
        do
          {:ok, messageMulti.record}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end
    end

    @desc "删除私信"
    field :delete_message, :message_payload do
      arg :id, non_null(:id)
      middleware Middleware.Authorize

      resolve fn (%{id: id}, %{context: context}) ->
        message = Messages.get_message(id)
        case Messages.is_message_author(context[:current_user], message) do
          true -> message |> Messages.delete_message()
          {:error, msg} -> {:ok, generic_message(msg)}
        end
      end
    end
  end
end
