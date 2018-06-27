defmodule NsgAcsWeb.SessionController do
  use NsgAcsWeb, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    conn = put_layout(conn, false)
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    # here will be an implementation
    render(conn, "new.html")
  end

  def delete(conn, _) do
    # here will be an implementation
    conn
  end
end
