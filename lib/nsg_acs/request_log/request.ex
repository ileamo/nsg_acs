defmodule NsgAcs.RequestLog.Request do
  use Ecto.Schema
  import Ecto.Changeset


  schema "requests" do
    field :from, :string
    field :request, :map
    field :response, :string

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:from, :request, :response])
    |> validate_required([:from, :request, :response])
  end
end
