defmodule NsgAcs.LinkSupervisor do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(sock) do
    DynamicSupervisor.start_child(
      __MODULE__,
      NsgAcs.Link.child_spec(sock)
    )
  end
end
