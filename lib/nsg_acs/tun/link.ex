defmodule NsgAcs.Link do
  require Logger
  use GenServer, restart: :temporary

  def start_link(sock) do
    GenServer.start_link(__MODULE__, sock)
  end

  ## Callbacks
  @impl true
  def init(sock) do
    Logger.debug("START LINK: #{inspect(sock)}")
    :ssl.controlling_process(sock, self())
    {:ok, sslsock} = :ssl.handshake(sock)
    {:ok, %{sslsocket: sslsock, pid: self()}, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, state) do
    case NsgAcs.Iface.start_child(state) do
      {:ok, pid} ->
        Logger.debug("Iface pid: #{inspect(pid)}")
        {:noreply, state |> Map.put(:iface_pid, pid)}

      {:error, error} ->
        Logger.error("Can't create link server: #{inspect(error)}")
        {:stop, error, state}
    end
  end

  @impl true
  def handle_cast(:terminate, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_cast({:send, packet}, state = %{sslsocket: sslsocket}) do
    :ssl.send(sslsocket, packet)
    Logger.debug("SSL SEND #{byte_size(packet)} bytes")
    {:noreply, state}
  end

  @impl true
  def handle_info({:ssl, _sslsocket, data}, state = %{iface_pid: iface_pid}) do
    Logger.debug("SSL RECEIVE #{length(data)} bytes")
    GenServer.cast(iface_pid, {:send, data})
    {:noreply, state}
  end

  def handle_info({:ssl_closed, _sslsocket}, state) do
    {:stop, :normal, state}
  end

  def handle_info({:ssl_error, _sslsocket, _reason}, state) do
    {:stop, :normal, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Link server: unknown message: #{inspect(msg)}")
    {:noreply, state}
  end

  # Client
  def start_child(sock) do
    DynamicSupervisor.start_child(
      NsgAcs.LinkSupervisor,
      child_spec(sock)
    )
  end
end
