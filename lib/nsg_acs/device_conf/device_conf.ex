defmodule NsgAcs.DeviceConf do
  @moduledoc """
  The DeviceConf context.
  """

  import Ecto.Query, warn: false
  alias NsgAcs.Repo

  alias NsgAcs.DeviceConf.Device

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Device
    |> Repo.all()
    |> Repo.preload(:group)
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id) do
    Device
    |> Repo.get!(id)
    |> Repo.preload(:group)
  end

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(attrs \\ %{}) do
    attrs = %{
      key: attrs["key"],
      params: %{a: 12, b: 24},
      group_id: String.to_integer(attrs["group_id"])
    }

    %Device{}
    |> Device.changeset(attrs)
    |> Ecto.Changeset.put_change(:group_id, attrs.group_id)
    |> Repo.insert()
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{source: %Device{}}

  """
  def change_device(%Device{} = device) do
    Device.changeset(device, %{})
  end
end
