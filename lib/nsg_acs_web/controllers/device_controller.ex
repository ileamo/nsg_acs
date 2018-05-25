defmodule NsgAcsWeb.DeviceController do
  use NsgAcsWeb, :controller

  alias NsgAcs.DeviceConf
  alias NsgAcs.DeviceConf.Device

  def index(conn, _params) do
    devices = DeviceConf.list_devices()
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    changeset = DeviceConf.change_device(%Device{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device" => device_params}) do
    case DeviceConf.create_device(device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)
    render(conn, "show.html", device: device)
  end

  def edit(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)
    changeset = DeviceConf.change_device(device)
    render(conn, "edit.html", device: device, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = DeviceConf.get_device!(id)

    case DeviceConf.update_device(device, device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)
    {:ok, _device} = DeviceConf.delete_device(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: device_path(conn, :index))
  end
end
