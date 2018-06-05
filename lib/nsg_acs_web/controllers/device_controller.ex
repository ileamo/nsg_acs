defmodule NsgAcsWeb.DeviceController do
  use NsgAcsWeb, :controller

  alias NsgAcs.DeviceConf
  alias NsgAcs.DeviceConf.Device
  alias NsgAcs.GroupConf

  def index(conn, _params) do
    devices = DeviceConf.list_devices()
    render(conn, "index.html", devices: devices)
  end

  def new(conn, %{"group_id" => group_id}) do
    changeset = DeviceConf.change_device(%Device{})
    group = GroupConf.get_group!(group_id)
    params = GroupConf.get_params_from_template(group.template)
    render(conn, "new.html", changeset: changeset, group_id: group_id, params: params)
  end

  def create(conn, %{"device" => device, "params" => params}) do
    device = Map.put(device, "params", params)

    case DeviceConf.create_device(device) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device created successfully.")
        |> redirect(to: device_path(conn, :show, device))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, group_id: device["group_id"])
    end
  end

  def show(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)
    render(conn, "show.html", device: device)
  end

  def edit(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)
    changeset = DeviceConf.change_device(device)
    render(conn, "edit.html", device: device, changeset: changeset, group_id: device.group.id)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = DeviceConf.get_device!(id)

    case DeviceConf.update_device(device, device_params) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          device: device,
          changeset: changeset,
          group_id: device_params["group_id"]
        )
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
