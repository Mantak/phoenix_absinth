defmodule NearbyBook.Repo.Migrations.CreateMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      # sender_id 与users的id关联
      add(:sender_id, references(:users, on_delete: :delete_all, type: :uuid), null: false)
      # reciver_id 与users的id关联
      add(:receiver_id, references(:users, on_delete: :delete_all, type: :uuid), null: false)
      add(:readed, :boolean, default: false)
      add(:content, :string)

      timestamps()
    end
  end
end
