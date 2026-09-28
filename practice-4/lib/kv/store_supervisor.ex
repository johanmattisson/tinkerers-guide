# A supervisor for our stores. If a store crashes, this starts a new one.
defmodule KV.StoreSupervisor do
  use Supervisor

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      # Step 2: add a store called "groceries" here.
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
