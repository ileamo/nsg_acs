defmodule NsgAcsWeb.NewdevController do
  use NsgAcsWeb, :controller

  alias NsgAcs.Discovery
  alias NsgAcs.GroupConf

  def index(conn, _params) do
    newdevs = Discovery.list_newdevs()
    render(conn, "index.html", newdevs: newdevs)
  end

  def new(conn, params) do
    {res, newdev, env} =
      with {:ok, env = %{key: key}} <- get_env(params),
           :ok <- new_dev?(key) do
        add_discovery(conn, env)
      else
        {:error, message} -> {message, nil, nil}
      end

    render(conn, "new.html", params: params, res: res, env: env, newdev: newdev)
  end

  defp get_env(%{"text" => text}) when is_binary(text) do
    ~r/([^\s=,;]+)\s*=\s*([^\s=,;]+)/
    |> Regex.scan(text)
    |> Enum.map(fn [_, k, v] -> {k, v} end)
    |> Enum.into(%{})
    |> find_key()
  end

  defp get_env(_), do: {:error, "Содержимое QR кода должно быть передано в параметре text"}

  defp find_key(parms = %{"key" => key}), do: {:ok, parms |> Map.put(:key, key)}

  defp find_key(parms = %{"dev" => dev, "sn" => sn}),
    do: {:ok, parms |> Map.put(:key, "#{dev}_#{sn}")}

  defp find_key(_), do: {:error, "Не удалось найти значение ключа"}

  defp new_dev?(key) do
    (NsgAcs.DeviceConf.get_device_by_key(key) && {:error, "Устройство уже зарегистрировано"}) ||
      :ok
  end

  defp add_discovery(%{remote_ip: ip}, env) do
    case Discovery.insert_or_update_newdev(%{
           from: ip |> :inet.ntoa() |> to_string(),
           source: "discovery",
           key: env.key,
           group: env["group"] || "UNKNOWN"
         }) do
      {:ok, newdev} -> {"Устройство добавлено в базу", newdev, env}
      {:error, newdev} -> {"Ошибка БД: #{inspect(newdev.errors)}", nil, env}
    end
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

  def update(conn, %{"id" => id, "newdev" => %{"group" => group_name, "key" => key}}) do
    Discovery.get_newdev!(id) |> Discovery.delete_newdev()

    %{id: id} = GroupConf.get_group_by_name(group_name)

    conn
    |> redirect(to: device_path(conn, :new, group_id: id, group_name: group_name, key: key))
  end
end
