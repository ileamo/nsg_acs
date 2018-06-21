defmodule NsgAcsWeb.Api.DeviceController do
  use NsgAcsWeb, :controller

  alias NsgAcs.DeviceConf
  alias NsgAcs.GroupConf

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

  def index(conn, %{"id" => id}) do
    render(conn, "error.json", %{id: id, error: "no method and/or params field"})
  end

  def index(conn, _) do
    render(conn, "error.json", %{id: 0, error: "no request id"})
  end

  defp get_res("get.conf", %{"nsg_device" => dev, "serial_num" => sn}) do
    key = "#{dev}_#{sn}"

    case DeviceConf.get_device_by_key(key) do
      %{} = device -> {:ok, %{configuration: GroupConf.get_conf_from_template(device)}}
      _ -> {:error, "no configuration for key #{key}"}
    end
  end

  defp get_res("get.conf", _) do
    {:error, "no nsg_device or serial_num"}
  end

  defp get_res(_, _) do
    {:error, "unknown method"}
  end
end
