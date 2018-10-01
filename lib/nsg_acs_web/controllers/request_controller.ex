defmodule NsgAcsWeb.RequestController do
  use NsgAcsWeb, :controller

  alias NsgAcs.RequestLog

  def index(conn, _params) do
    requests = RequestLog.list_requests()
    render(conn, "index.html", requests: requests)
  end

  def show(conn, %{"id" => id}) do
    request = RequestLog.get_request!(id)
    render(conn, "show.html", request: request)
  end

  def delete(conn, %{"id" => id}) do
    request = RequestLog.get_request!(id)
    {:ok, _request} = RequestLog.delete_request(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: request_path(conn, :index))
  end
end
