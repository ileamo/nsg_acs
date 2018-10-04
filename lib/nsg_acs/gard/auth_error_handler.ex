defmodule NsgAcs.Guard.AuthErrorHandler do
  @moduledoc false

  import NsgAcsWeb.Router.Helpers

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> Phoenix.Controller.redirect(
      to: session_path(conn, :new, prev_path: "#{conn.request_path}?#{conn.query_string}")
    )
  end
end
