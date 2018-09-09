defmodule NearbyBookWeb.Graphql.Accounts.Mutations do
  use Absinthe.Schema.Notation

  import Kronky.Payload
  import NearbyBookWeb.Helpers.ValidationMessageHelpers

  alias NearbyBookWeb.Middleware
  alias NearbyBook.Accounts

  payload_object(:user_payload, :user)

  object :accounts_mutations do
    @desc "Sign up"
    field :sign_up, :user_payload do
      arg :email, :string
      arg :password, :string
      arg :password_confirmation, :string

      resolve fn (args, _) ->
        with {:ok, user} <- Accounts.create_user(args),
          {:ok, _token, user_with_token} <- Accounts.generate_access_token(user)
        do
          {:ok, user_with_token}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          _ -> {:error, "可能没有权限，反正是出错了"}
        end
      end
    end

    @desc "Update current user profile"
    field :update_user, :user_payload do
      arg :email, :string
      arg :nick_name, :string
      arg :avatar_url, :string
      arg :location, list_of(:float)
      middleware Middleware.Authorize

      resolve fn (args, %{context: context}) ->
        case context[:current_user] |> Accounts.update_user(args) do
          {:ok, user} -> {:ok, user}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end
    end

    @desc "Change user password"
    field :change_password, :user_payload do
      arg :password, :string
      arg :password_confirmation, :string
      arg :current_password, :string
      middleware Middleware.Authorize

      resolve fn (args, %{context: context}) ->
        with {:ok, _user} <- Accounts.authenticate(context[:current_user].email, args[:current_password]),
          {:ok, user} <- context[:current_user] |> Accounts.change_password(args)
        do
          {:ok, user}
        else
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
          {:error, _msg} -> {:ok, message(:current_password, "原始密码不正确")}
        end
      end
    end

    @desc "Cancel Account"
    field :cancel_account, :boolean do
      middleware Middleware.Authorize
      resolve fn (_, %{context: context}) ->
        context[:current_user] |> Accounts.cancel_account()
        {:ok, true}
      end
    end
  end
end
