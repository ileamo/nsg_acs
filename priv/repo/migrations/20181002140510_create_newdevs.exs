defmodule NsgAcs.Repo.Migrations.CreateNewdevs do
  use Ecto.Migration

  def change do
    create table(:newdevs) do
      add :key, :string
      add :from, :string
      add :source, :string
      add :group, :string

      timestamps()
    end

    create unique_index(:newdevs, [:key])
  end
end
