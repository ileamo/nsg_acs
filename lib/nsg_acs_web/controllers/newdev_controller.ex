defmodule NsgAcsWeb.NewdevController do
  use NsgAcsWeb, :controller

  alias NsgAcs.Discovery
  alias NsgAcs.Discovery.Newdev

  def index(conn, _params) do
    newdevs = Discovery.list_newdevs()
    render(conn, "index.html", newdevs: newdevs)
  end

  def new(conn, params) do
    res =
      with {:ok, key} <- get_key(params),
           :ok <- new_dev?(key) do
        add_discovery(conn, params)
      else
        {:error, message} -> message
      end

    render(conn, "new.html", params: params, res: res)
  end

  defp get_key(%{"key" => key}) when is_binary(key), do: {:ok, key}
  defp get_key(_), do: {:error, "Отсутствует параметр key"}

  defp new_dev?(key) do
    (NsgAcs.DeviceConf.get_device_by_key(key) && {:error, "Устройство уже зарегистрировано"}) ||
      :ok
  end

  defp add_discovery(%{remote_ip: ip}, params) do
    Discovery.insert_or_update_newdev(%{
      from: ip |> :inet.ntoa() |> to_string(),
      source: "discovery",
      key: params["key"],
      group: params["group"] || "UNKNOWN"
    })

    "Устройство добавлено в базу"
  end

  def delete(conn, %{"id" => id}) do
    newdev = Discovery.get_newdev!(id)
    {:ok, _newdev} = Discovery.delete_newdev(newdev)

    conn
    |> put_flash(:info, "Newdev deleted successfully.")
    |> redirect(to: newdev_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    newdev = Discovery.get_newdev!(id)
    changeset = Discovery.change_newdev(newdev)
    render(conn, "edit.html", newdev: newdev, changeset: changeset)
  end

  def update(conn, params) do
    IO.inspect(params)

    conn
    |> redirect(to: newdev_path(conn, :index))
  end
end
