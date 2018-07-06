defmodule NsgAcs.Auth.AuthAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :nsg_acs

  plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
