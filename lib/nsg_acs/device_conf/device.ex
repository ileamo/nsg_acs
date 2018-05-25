defmodule NsgAcs.DeviceConf.Device do
  use Ecto.Schema
  import Ecto.Changeset


  schema "devices" do
    field :key, :string
    field :params, :map
    field :group_id, :id

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:key, :params])
    |> validate_required([:key, :params])
    |> unique_constraint(:key)
  end
end
