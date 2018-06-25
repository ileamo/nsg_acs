defmodule NsgAcsWeb.RequestController do
  use NsgAcsWeb, :controller

  alias NsgAcs.RequestLog
  alias NsgAcs.RequestLog.Request

  def index(conn, _params) do
    requests = RequestLog.list_requests()
    render(conn, "index.html", requests: requests)
  end

  def new(conn, _params) do
    changeset = RequestLog.change_request(%Request{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"request" => request_params}) do
    case RequestLog.create_request(request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request created successfully.")
        |> redirect(to: request_path(conn, :show, request))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    request = RequestLog.get_request!(id)
    render(conn, "show.html", request: request)
  end

  def edit(conn, %{"id" => id}) do
    request = RequestLog.get_request!(id)
    changeset = RequestLog.change_request(request)
    render(conn, "edit.html", request: request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = RequestLog.get_request!(id)

    case RequestLog.update_request(request, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: request_path(conn, :show, request))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = RequestLog.get_request!(id)
    {:ok, _request} = RequestLog.delete_request(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: request_path(conn, :index))
  end
end
