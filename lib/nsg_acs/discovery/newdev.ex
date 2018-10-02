defmodule NsgAcs.Discovery.Newdev do
  use Ecto.Schema
  import Ecto.Changeset


  schema "newdevs" do
    field :from, :string
    field :group, :string
    field :key, :string
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(newdev, attrs) do
    newdev
    |> cast(attrs, [:key, :from, :source, :group])
    |> validate_required([:key, :from, :source, :group])
    |> unique_constraint(:key)
  end
end
