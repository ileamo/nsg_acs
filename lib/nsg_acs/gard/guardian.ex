defmodule NsgAcs.Guard.Guardian do
  @moduledoc false

  use Guardian, otp_app: :nsg_acs

  alias NsgAcs.Auth

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Auth.get_user!(id)
    {:ok, user}
  end
end
