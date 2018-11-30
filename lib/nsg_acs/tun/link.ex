defmodule NsgAcs.Link do
  require Logger
  use GenServer, restart: :temporary

  def start_link(sock) do
    GenServer.start_link(__MODULE__, sock)
  end

  ## Callbacks
  @impl true
  def init(sock) do
    :ssl.controlling_process(sock, self())
    {:ok, sslsock} = :ssl.handshake(sock)

    {:ok, %{sslsocket: sslsock}}
  end

  @impl true
  def handle_info({:ssl, sslsocket, data}, state) do
    Logger.debug("Receive data: #{data}")
    :ssl.send(sslsocket, "echo #{data}")
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
end
