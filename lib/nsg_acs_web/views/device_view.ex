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

  def number_conf(conf) do
    conf
    |> String.split(["\n"])
    |> Enum.with_index(1)
    |> Enum.map(fn {str, n} ->
      "#{n |> Integer.to_string() |> String.pad_leading(3, " ")} #{str}"
    end)
    |> Enum.join("\n")
  end

  def validate_conf(conf) do
    "Error"
  end

  def device_and_key_params(device) do
    GroupConf.get_params_from_key(device)
  end
end
