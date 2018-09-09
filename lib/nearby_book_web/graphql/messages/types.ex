defmodule NearbyBookWeb.Graphql.Messages.Types do
  use Absinthe.Schema.Notation
  # 就是这个Absinthe.Ecto定义了assoc
  use Absinthe.Ecto, repo: NearbyBook.Repo

  input_object :message_input do
    field(:receiver_id, :string)
    field(:content, :string)
  end

  object :message do
    field(:id, :id)
    field(:content, :string)
    field(:readed, :boolean)
    field(:inserted_at, :datetime)
    field(:sender, :user_info, resolve: assoc(:sender))
  end

  object :message_list do
    field(:page_number, :integer)
    field(:page_size, :integer)
    field(:total_entries, :integer)
    field(:total_pages, :integer)
    field(:entries, list_of(:message))
  end
end
