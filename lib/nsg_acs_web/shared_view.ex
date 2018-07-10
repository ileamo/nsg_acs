defmodule NsgAcsWeb.SharedView do
  use NsgAcsWeb, :view

  def is_admin(conn) do
    conn.assigns.current_user.is_admin
  end
end
