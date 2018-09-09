defmodule NearbyBook.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:email, :string, size: 254, null: false)
      add(:password_hash, :string, null: false)
      add(:access_token, :string)
      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
