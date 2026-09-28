# Practice 4: Solutions

Try the hints in `README.md` first! Use this file when you are really stuck, or to compare with your own code.

The extras have their solutions in the hints in `README.md`.

## Exercise A

Exercise A has no code to write. Everything is in the steps in `README.md`.

## Exercise B

You only change these two files. `lib/kv.ex` stays the same.

### `lib/kv/store_supervisor.ex`

```elixir
# A supervisor for our stores. If a store crashes, this starts a new one.
defmodule KV.StoreSupervisor do
  use Supervisor

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      # Each child needs its own id. Both stores are KV, so we set the ids ourselves.
      Supervisor.child_spec({KV, "groceries"}, id: :groceries),
      Supervisor.child_spec({KV, "todo"}, id: :todo)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

### `lib/kv/application.ex`

```elixir
defmodule KV.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # The Registry must come first: the stores register in it when they start.
      {Registry, keys: :unique, name: KV.Registry},
      KV.StoreSupervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: KV.Supervisor)
  end
end
```
