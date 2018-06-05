defmodule NsgAcs.DeviceConf.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :key, :string, default: "NSG0000_0000000000"
    field :params, :map
    belongs_to :group, NsgAcs.GroupConf.Group

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
