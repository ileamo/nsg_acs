defmodule NsgAcs.Iface do
  require Logger
  use GenServer, restart: :temporary

  @moduledoc """
  For IPv4 addresses, beam needs to have privileges to configure interfaces.
  To add cap_net_admin capabilities:
  sudo setcap cap_net_admin=ep /path/to/bin/beam.smp
  """

  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
  end

  ## Callbacks
  @impl true
  def init(state) do
    {:ok, ref} = :tuncer.create(<<>>, [:tun, :no_pi, active: true])
    :tuncer.up(ref, '192.168.123.4')
    name = :tuncer.devname(ref)
    Logger.debug("Create iface #{name}")
    {:ok, state |> Map.put(:ifname, name)}
  end

  @impl true
  def handle_info({:tuntap, _pid, packet}, state) do
    Logger.debug("Iface #{state[:name]}: receive #{byte_size(packet)} bytes #{inspect(packet)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Iface server: unknown message: #{inspect(msg)}")
    {:noreply, state}
  end

  def start_child(params \\ %{}) do
    DynamicSupervisor.start_child(
      NsgAcs.LinkSupervisor,
      child_spec(params)
    )
  end
end
