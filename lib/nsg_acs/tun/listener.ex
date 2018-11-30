defmodule NsgAcs.Listener do
  use Task, restart: :permanent
  alias NsgAcs.LinkSupervisor

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    {:ok, l} =
      :ssl.listen(7000,
        certfile: "certificate.pem",
        keyfile: "key.pem",
        reuseaddr: true,
        packet: 2
      )

    accept_loop(l)
  end

  defp accept_loop(l) do
    {:ok, sock} = :ssl.transport_accept(l)
    {:ok, _pid} = LinkSupervisor.start_child(sock)
    accept_loop(l)
  end
end
