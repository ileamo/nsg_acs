defmodule NsgAcs.Guard do
  alias NsgAcs.Guard.Guardian
  alias Plug.Conn

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> Conn.assign(:current_user, user)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
  end

  def load_current_user(conn, _) do
    conn
    |> Conn.assign(:current_user, Guardian.Plug.current_resource(conn))
  end

  def is_admin(conn = %{assigns: %{current_user: %{is_admin: true}}}, _opts) do
    conn
  end

  def is_admin(conn, _opts) do
    conn
    |> Conn.halt()
  end
end
