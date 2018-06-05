defmodule NsgAcsWeb.DeviceView do
  use NsgAcsWeb, :view

  def param_list(param_map) do
    param_map
    |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
    |> Enum.join(", ")
  end
end
