# Practice 3: Solutions

Try the hints in `README.md` first! Use this file when you are really stuck, or to compare with your own code.

The extras have their solutions in the hints in `README.md`.

## Exercise A

Exercise A has no code to write. Everything is in the steps in `README.md`.

## Exercise B

You only change `lib/kv.ex`. `lib/kv/application.ex` stays the same.

### `lib/kv.ex`

```elixir
defmodule KV do
  use GenServer

  @registry KV.Registry

  # --- Client API: runs in the caller's process ---

  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  def put(name, key, value) do
    GenServer.call(whereis(name), {:put, key, value})
  end

  def get(name, key) do
    GenServer.call(whereis(name), {:get, key})
  end

  def delete(name, key) do
    GenServer.call(whereis(name), {:delete, key})
  end

  # Turns a name into a pid. Returns nil if no store has that name.
  def whereis(name) do
    case Registry.lookup(@registry, name) do
      [{pid, _value}] -> pid
      [] -> nil
    end
  end

  # --- Server callbacks: run in the store's own process ---

  @impl true
  def init(name) do
    # This runs inside the new store process, so it registers itself.
    {:ok, _owner} = Registry.register(@registry, name, nil)
    {:ok, %{}}
  end

  @impl true
  def handle_call({:put, key, value}, _from, map) do
    {:reply, :ok, Map.put(map, key, value)}
  end

  def handle_call({:get, key}, _from, map) do
    {:reply, Map.get(map, key), map}
  end

  def handle_call({:delete, key}, _from, map) do
    {:reply, :ok, Map.delete(map, key)}
  end
end
```
