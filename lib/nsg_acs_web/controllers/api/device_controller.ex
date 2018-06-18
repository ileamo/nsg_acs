defmodule NsgAcsWeb.Api.DeviceController do
  use NsgAcsWeb, :controller

  alias NsgAcs.DeviceConf
  alias NsgAcs.DeviceConf.Device

  action_fallback(NsgAcsWeb.FallbackController)

  @doc """
  For testing use curl:

  curl -H "Content-Type: application/json" -X POST \
    -d '{"id":1,"method":"get.conf","params":{"serial_num":"1234567890","nsg_device":"nsg1700"}}' \
    http://localhost:5000/api

  """

  def index(conn, %{"id" => id, "method" => method, "params" => params}) do
    case get_res(method, params) do
      {:ok, res} -> render(conn, "result.json", %{id: id, result: res})
      {:error, err} -> render(conn, "error.json", %{id: id, error: err})
    end
  end

  def get_res("get.conf", params) do
    {:ok, params}
  end

  def get_res(_, _) do
    {:error, "unknown method"}
  end
end
