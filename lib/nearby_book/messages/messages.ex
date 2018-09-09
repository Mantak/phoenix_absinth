defmodule NearbyBook.Messages do
  @moduledoc """
  The Messages context.
  """
  import Ecto.Query
  import Ecto.Changeset, only: [put_assoc: 3]

  alias NearbyBook.{Repo, Accounts, Messages}
  alias Accounts.User
  alias Messages.Message

  @doc """
  为查询生成query片段
  """
  def search_message(query, nil), do: query

  def search_message(query, keywords) do
    from(r in query,
      where: ilike(r.content, ^"%#{keywords}%")
    )
  end

  @doc """
  判断是否是当前用户，在更新或删除数据的时候用到
  """
  def is_message_author(%User{} = author, %Message{} = message) do
    if message.sender_id == author.id do
      true
    else
      {:error, "这不是你的私信!"}
    end
  end

  @doc """
  Gets someone's messages.
  """
  def user_messages(user_id, page, keywords) do
    Message
    |> Messages.search_message(keywords)
    |> where(receiver_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(page: page, page_size: 1)
  end

  @doc """
  Gets a message by its id.
  """
  @spec get_message(term) :: Message.t() | nil
  def get_message(id), do: Repo.get(Message, id)

  @doc """
  Creates a message.
  """
  def create_message(user, attrs) do
    attrs
    |> Message.changeset()
    |> put_assoc(:sender, user)
    |> Repo.insert()
  end

  @doc """
  Updates a message.
  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.
  """
  def delete_message(%Message{} = message), do: Repo.delete(message)
end
