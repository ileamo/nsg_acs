defmodule NsgAcsWeb.DeviceView do
  use NsgAcsWeb, :view
  alias NsgAcs.GroupConf

  def param_list(param_map) do
    param_map
    |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
    |> Enum.join(", ")
  end

  def get_conf(tp, params) do
    GroupConf.get_conf_from_template(tp, params)
  end
end
