defmodule Demo.CounterSupervisor do
  use Supervisor

  def start_link(_arg), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl true
  def init(:ok) do
    children = [
      Supervisor.child_spec({NamedCounter, "alice"}, id: :alice),
      Supervisor.child_spec({NamedCounter, "bob"}, id: :bob)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
