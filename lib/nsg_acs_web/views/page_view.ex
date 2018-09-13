defmodule NsgAcsWeb.PageView do
  use NsgAcsWeb, :view

  def version() do
    {:ok, ver} = :application.get_key(:nsg_acs, :vsn)
    ver
  end
end
