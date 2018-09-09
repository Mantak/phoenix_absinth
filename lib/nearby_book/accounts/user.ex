defmodule NearbyBook.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias NearbyBook.{Messages}
  alias Messages.Message

  @type t :: %User{}

  @permitted_attrs [
    :email
  ]

  @create_attrs [
    :password,
    :password_confirmation,
    :email
  ]

  @required_attrs [
    :email
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)
    field(:access_token, :string)

    has_many(:messages, Message, foreign_key: :receiver_id)

    # 第三个参数，可以是表名，可以是schema的模块名，这里因为是多对多表，没必要
    # 建立模块，所以就直接写了表名
    timestamps(type: :utc_datetime)
  end

  def changeset(%User{} = user, attrs \\ %{}) do
    attrs = attrs |> Map.delete(:password)

    user
    |> cast(attrs, @permitted_attrs)
    |> validate_required(@required_attrs)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def changeset(%User{} = user, attrs, :password) do
    user
    |> cast(attrs, @create_attrs)
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "不匹配")
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  # In case the association was already loaded, preload won’t attempt to reload it.
  # 无论是多对多，还是一对多，排序很难，分页更不可能，所以，不要通过assoc来获取数据了
  # 要获取数据，直接写获取数据的接口
  # def preload_books(%User{} = user), do: Repo.preload(user, :books)
end
