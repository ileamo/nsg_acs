defmodule NsgAcsWeb.GroupView do
  use NsgAcsWeb, :view

  alias NsgAcs.GroupConf

  def str_head(str, len) do
    str
    |> String.slice(0, len)
    |> Kernel.<>(" ...")
  end

  def get_params(templ) do
    templ
    |> GroupConf.get_params_from_template()
    |> Map.keys()
    |> Enum.join(", ")
  end
end
