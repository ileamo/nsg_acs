defmodule NsgAcs.Guard do
  use NsgAcsWeb, :controller
  alias NsgAcs.Guard.Guardian

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
  end

  def load_current_user(conn, _) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end

  def is_admin(conn = %{assigns: %{current_user: %{is_admin: true}}}, _opts) do
    conn
  end

  def is_admin(conn, _opts) do
    conn
    |> halt()
  end
end
