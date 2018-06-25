defmodule NsgAcs.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :from, :string
      add :request, :map
      add :response, :string

      timestamps()
    end

  end
end
