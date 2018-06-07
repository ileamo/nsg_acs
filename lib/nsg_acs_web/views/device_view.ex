defmodule NsgAcsWeb.DeviceView do
  use NsgAcsWeb, :view
  alias NsgAcs.GroupConf

  def param_list(param_map) do
    param_map
    |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
    |> Enum.join(", ")
  end

  def get_conf(device) do
    GroupConf.get_conf_from_template(device)
  end

  def device_and_key_params(device) do
    GroupConf.get_params_from_key(device)
  end
end
