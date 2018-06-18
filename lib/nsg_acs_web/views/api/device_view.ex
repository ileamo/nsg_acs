defmodule NsgAcsWeb.Api.DeviceView do
  use NsgAcsWeb, :view
  alias NsgAcsWeb.Api.DeviceView

  def render("result.json", %{id: id, result: result}) do
    %{"id" => id, "result" => result}
  end

  def render("error.json", %{id: id, error: err}) do
    %{"id" => id, "error" => err}
  end
end
