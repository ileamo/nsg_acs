defmodule NsgAcs.Iface do
  require Logger
  use GenServer, restart: :temporary

  @moduledoc """
  For IPv4 addresses, beam needs to have privileges to configure interfaces.
  To add cap_net_admin capabilities:
  lubuntu:
  sudo setcap cap_net_admin=ep /usr/lib/erlang/erts-10.1/bin/beam.smp cap_net_admin=ep /bin/ip
  """

  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
  end

  ## Callbacks
  @impl true
  def init(state) do
    {:ok, ref} = :tuncer.create(<<>>, [:tun, :no_pi, active: true])
    name = :tuncer.devname(ref)

    with {_, 0} <-
           System.cmd(
             "ip",
             ["address", "add", "192.168.123.4/32", "peer", "192.168.123.5", "dev", name],
             stderr_to_stdout: true
           ),
         {_, 0} <- System.cmd("ip", ["link", "set", name, "up"], stderr_to_stdout: true) do
      Logger.debug("Create iface #{name}")
      {:ok, state |> Map.put(:ifname, name)}
    else
      {err, _} ->
        Logger.error(err)
        :tuncer.destroy(ref)
        {:stop, err}
    end
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
