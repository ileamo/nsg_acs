defmodule NsgAcs.TunSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      NsgAcs.Listener,
      NsgAcs.LinkSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
