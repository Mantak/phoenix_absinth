defmodule NearbyBook.Accounts do
  import Ecto.Query, only: [from: 2]

  alias NearbyBook.Repo
  alias NearbyBook.Accounts.User

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs, :password)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_password(%User{} = user, %{
        password: password,
        password_confirmation: password_confirmation
      }) do
    user
    |> User.changeset(
      %{password: password, password_confirmation: password_confirmation},
      :password
    )
    |> Repo.update()
  end

  def cancel_account(%User{} = user) do
    user |> Repo.delete()
  end

  @doc """
  Generate an access token and associates it with the user
  """
  def generate_access_token(user) do
    access_token = generate_token(user)
    user_modified = Ecto.Changeset.change(user, access_token: access_token)
    {:ok, user} = Repo.update(user_modified)
    {:ok, access_token, user}
  end

  defp generate_token(user) do
    Base.encode64(
      :erlang.md5("#{:os.system_time(:milli_seconds)}-#{user.id}-#{SecureRandom.hex()}")
    )
  end

  def revoke_access_token(user) do
    user_modified = Ecto.Changeset.change(user, access_token: nil)
    {:ok, _user} = Repo.update(user_modified)
  end

  @doc """
  Authenticate user with email and password
  """
  def authenticate(nil, _password), do: {:error, "没有email无法登陆"}
  def authenticate(_email, nil), do: {:error, "密码不能为空不能登陆"}

  def authenticate(email, password) do
    user = User |> Repo.get_by(email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Email或密码错误"}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end
end
