defmodule NsgAcsWeb.Api.DeviceController do
  use NsgAcsWeb, :controller

  alias NsgAcs.DeviceConf
  alias NsgAcs.GroupConf
  alias NsgAcs.RequestLog
  alias NsgAcs.Discovery

  action_fallback(NsgAcsWeb.FallbackController)

  plug :validate_params
  plug :get_res

  defp validate_params(
         conn = %{
           params: %{
             "id" => _id,
             "method" => _method,
             "params" => %{}
           }
         },
         _
       ) do
    conn
  end

  defp validate_params(conn = %{params: %{"id" => id}}, _) do
    conn
    |> render_and_log_error(id, "No method or params field")
    |> halt()
  end

  defp validate_params(conn, _) do
    conn
    |> render_and_log_error(0, "No request id")
    |> halt()
  end

  defp get_res(
         conn = %{
           params: %{
             "id" => id,
             "method" => "get.conf",
             "params" => %{"nsg_device" => dev, "serial_num" => sn}
           }
         },
         _
       ) do
    key = "#{dev}_#{sn}"

    case DeviceConf.get_device_by_key(key) do
      %{} = device ->
        conn
        |> assign(:configuration, GroupConf.get_conf_from_template(device))

      _ ->
        conn
        |> render_and_log_error(id, "no configuration for key #{key}")
        |> add_discovery(key)
        |> halt()
    end
  end

  defp get_res(conn = %{params: %{"id" => id, "method" => "get.conf"}}, _) do
    conn
    |> render_and_log_error(id, "No nsg_device or serial_num")
    |> halt()
  end

  defp get_res(conn = %{params: %{"id" => id}}, _) do
    conn
    |> render_and_log_error(id, "Unknown method")
    |> halt()
  end

  @doc """
  For testing use curl:

  curl -H "Content-Type: application/json" -X POST \
    -d '{"id":1,"method":"get.conf","params":{"serial_num":"1234567890","nsg_device":"nsg1700"}}' \
    http://localhost:5000/api

  """

  def index(conn = %{assigns: %{configuration: conf}, params: %{"id" => id}}, _) do
    request_log(conn, "OK")
    render(conn, "result.json", %{id: id, result: %{configuration: conf}})
  end

  def index(conn = %{params: %{"id" => id}}, _) do
    render_and_log_error(conn, id, "No configuration")
  end

  defp render_and_log_error(conn, id, mes) do
    request_log(conn, "ERR: #{mes}")
    render(conn, "error.json", %{id: id, error: mes})
  end

  defp request_log(%{remote_ip: ip, params: %{"params" => params}}, mes) do
    RequestLog.create_request(%{
      from: ip |> :inet.ntoa() |> to_string(),
      request: params,
      response: mes
    })
  end

  defp request_log(_, _) do
  end

  defp add_discovery(conn = %{remote_ip: ip}, key) do
    Discovery.insert_or_update_newdev(%{
      from: ip |> :inet.ntoa() |> to_string(),
      source: "request",
      key: key
    })

    conn
  end
end
