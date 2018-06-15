defmodule NsgAcsWeb.Api.DeviceController do
  use NsgAcsWeb, :controller

  alias NsgAcs.DeviceConf
  alias NsgAcs.DeviceConf.Device

  action_fallback(NsgAcsWeb.FallbackController)

  @doc """
  For testing use curl:

  curl -H "Content-Type: application/json" -X POST \
  -d '{"serial_num":"1234567890", "nsg_device":"nsg1700"}' \
  http://localhost:5000/api

  """

  def index(conn, params) do
    IO.puts(inspect(params))
    devices = DeviceConf.list_devices()
    render(conn, "index.json", devices: devices)
  end

  def create(conn, %{"device" => device_params}) do
    with {:ok, %Device{} = device} <- DeviceConf.create_device(device_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_device_path(conn, :show, device))
      |> render("show.json", device: device)
    end
  end

  def show(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)
    render(conn, "show.json", device: device)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = DeviceConf.get_device!(id)

    with {:ok, %Device{} = device} <- DeviceConf.update_device(device, device_params) do
      render(conn, "show.json", device: device)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = DeviceConf.get_device!(id)

    with {:ok, %Device{}} <- DeviceConf.delete_device(device) do
      send_resp(conn, :no_content, "")
    end
  end
end
