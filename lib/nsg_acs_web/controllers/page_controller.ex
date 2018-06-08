defmodule NsgAcsWeb.PageController do
  use NsgAcsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    conn = put_layout(conn, false)
    render(conn, "login.html")
  end
end
