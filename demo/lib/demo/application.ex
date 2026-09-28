defmodule Demo.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Demo.Registry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Demo.Supervisor)
  end
end
