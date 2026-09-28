# This starts when you run `iex -S mix`. You don't need to change it today.
defmodule KV.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: KV.Registry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: KV.Supervisor)
  end
end
