defmodule NearbyBook.Messages.Message do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias NearbyBook.Accounts.User

  @type t :: %Message{}

  @permitted_attrs [
    :receiver_id,
    :content
  ]

  @required_attrs [
    :receiver_id,
    :content
  ]

  @update_permitted_attrs [
    :content,
    :readed
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field(:content, :string)
    field(:readed, :boolean)
    # belongs_to(name, queryable, opts \\ [])
    # 类似于定义了一个sender_id的键，与User.id关联
    # 可以通过put_assoc添加一个model也可以通过sender_id的键直接添加内容
    belongs_to(:sender, User)
    belongs_to(:receiver, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(attrs) do
    %Message{}
    |> cast(attrs, @permitted_attrs)
    |> validate_required(@required_attrs)
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, @update_permitted_attrs)
  end
end
