defmodule NsgAcs.Link do
  require Logger
  use GenServer, restart: :temporary
  alias NsgAcs.Iface

  def start_link(sock) do
    GenServer.start_link(__MODULE__, sock)
  end

  ## Callbacks
  @impl true
  def init(sock) do
    Logger.debug("START LINK: #{inspect(sock)}")
    :ssl.controlling_process(sock, self())
    {:ok, sslsock} = :ssl.handshake(sock)
    {:ok, sender_pid} = NsgAcs.LinkSender.start_link(%{sslsocket: sslsock})
    {:ok, %{sslsocket: sslsock, pid: self(), sender_pid: sender_pid}, {:continue, :init}}
  end

  @impl true
  def handle_continue(:init, %{sender_pid: sender_pid} = state) do
    case NsgAcs.Iface.start_child(state) do
      {:ok, iface_pid} ->
        ifsender_pid = Iface.get_ifsender_pid(iface_pid)
        Iface.set_link_sender_pid(iface_pid, self(), sender_pid)

        {:noreply, state |> Map.merge(%{iface_pid: iface_pid, ifsender_pid: ifsender_pid})}

      {:error, error} ->
        Logger.error("Can't create link server: #{inspect(error)}")
        {:stop, error, state}
    end
  end

  @impl true
  def handle_cast(:terminate, state) do
    {:stop, :shutdown, state}
  end

  @impl true
  def handle_info({:ssl, _sslsocket, data}, state = %{ifsender_pid: ifsender_pid}) do
    Logger.debug("SSL RECEIVE #{length(data)} bytes")
    GenServer.cast(ifsender_pid, {:send, data})
    {:noreply, state}
  end

  def handle_info({:ssl_closed, _sslsocket}, state) do
    Logger.warn("SSL CLOSED")
    {:stop, :shutdown, state}
  end

  def handle_info({:ssl_error, _sslsocket, _reason}, state) do
    Logger.warn("SSL ERROR")
    {:stop, :shutdown, state}
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

defmodule NsgAcs.LinkSender do
  require Logger
  use GenServer, restart: :temporary

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  ## Callbacks
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:send, packet}, state = %{sslsocket: sslsocket}) do
    :ssl.send(sslsocket, packet)
    Logger.debug("SEND TO SSL #{byte_size(packet)} bytes")
    {:noreply, state}
  end
end
