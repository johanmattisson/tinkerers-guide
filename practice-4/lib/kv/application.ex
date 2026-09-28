defmodule KV.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: KV.Registry}
      # Step 3: add KV.StoreSupervisor here, after the Registry.
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: KV.Supervisor)
  end
end
