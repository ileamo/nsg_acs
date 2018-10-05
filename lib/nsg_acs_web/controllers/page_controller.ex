defmodule NsgAcsWeb.PageController do
  use NsgAcsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def discovery(conn, params) do
    redirect(conn, to: newdev_path(conn, :new, params))
  end
end
