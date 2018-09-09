defmodule NearbyBookWeb.Schema do
  use Absinthe.Schema

  import Kronky.Payload
  alias NearbyBookWeb.Middleware.TranslateMessages

  alias NearbyBookWeb.Graphql.{
    JSONType,
    Accounts,
    Messages
  }

  # 定义了时间和小数类型，具体看文档
  import_types(Absinthe.Type.Custom)
  import_types(Absinthe.Plug.Types)
  import_types(Kronky.ValidationMessageTypes)
  import_types(JSONType)

  import_types(Accounts.Types)
  import_types(Accounts.Queries)
  import_types(Accounts.Mutations)
  import_types(Accounts.AuthMutations)

  import_types(Messages.Types)
  import_types(Messages.Queries)
  import_types(Messages.Mutations)
  import_types(Messages.Subscriptions)

  query do
    import_fields(:accounts_queries)
    import_fields(:messages_queries)
  end

  mutation do
    import_fields(:auth_mutations)
    import_fields(:accounts_mutations)
    import_fields(:messages_mutations)
  end

  subscription do
    import_fields(:messages_subscriptions)
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    middleware ++ [&build_payload/2, TranslateMessages]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
