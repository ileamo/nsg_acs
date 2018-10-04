defmodule NsgAcsWeb.NewdevController do
  use NsgAcsWeb, :controller

  alias NsgAcs.Discovery
  alias NsgAcs.Discovery.Newdev

  def index(conn, _params) do
    newdevs = Discovery.list_newdevs()
    render(conn, "index.html", newdevs: newdevs)
  end

  def new(conn, params) do
    IO.inspect(params)
    render(conn, "new.html", params: params)
  end

  def create(conn, %{"newdev" => newdev_params}) do
    case Discovery.create_newdev(newdev_params) do
      {:ok, newdev} ->
        conn
        |> put_flash(:info, "Newdev created successfully.")
        |> redirect(to: newdev_path(conn, :show, newdev))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    newdev = Discovery.get_newdev!(id)
    render(conn, "show.html", newdev: newdev)
  end

  def edit(conn, %{"id" => id}) do
    newdev = Discovery.get_newdev!(id)
    changeset = Discovery.change_newdev(newdev)
    render(conn, "edit.html", newdev: newdev, changeset: changeset)
  end

  def update(conn, %{"id" => id, "newdev" => newdev_params}) do
    newdev = Discovery.get_newdev!(id)

    case Discovery.update_newdev(newdev, newdev_params) do
      {:ok, newdev} ->
        conn
        |> put_flash(:info, "Newdev updated successfully.")
        |> redirect(to: newdev_path(conn, :show, newdev))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", newdev: newdev, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    newdev = Discovery.get_newdev!(id)
    {:ok, _newdev} = Discovery.delete_newdev(newdev)

    conn
    |> put_flash(:info, "Newdev deleted successfully.")
    |> redirect(to: newdev_path(conn, :index))
  end
end
