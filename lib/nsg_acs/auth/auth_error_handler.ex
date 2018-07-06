defmodule NsgAcs.Auth.AuthErrorHandler do
  @moduledoc false

  import NsgAcsWeb.Router.Helpers

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end
