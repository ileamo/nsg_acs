defmodule NsgAcs.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :key, :string
      add :params, :map
      add :group_id, references(:groups, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:devices, [:key])
    create index(:devices, [:group_id])
  end
end
