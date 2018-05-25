defmodule NsgAcs.GroupConf.Group do
  use Ecto.Schema
  import Ecto.Changeset


  schema "groups" do
    field :name, :string
    field :template, :string

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :template])
    |> validate_required([:name, :template])
    |> unique_constraint(:name)
  end
end
