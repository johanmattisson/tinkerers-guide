# Practice 2: Solutions

Try the hints in `README.md` first! Use this file when you are really stuck, or to compare with your own code.

The extras have their solutions in the hints in `README.md`.

## Exercise A

### `lib/counter.ex`

```elixir
defmodule Counter do
  use GenServer

  # --- Client API: runs in the caller's process ---

  def start_link(initial \\ 0), do: GenServer.start_link(__MODULE__, initial)
  def increment(pid), do: GenServer.call(pid, :increment)
  def get(pid), do: GenServer.call(pid, :get)
  def reset(pid), do: GenServer.cast(pid, :reset)

  def decrement(pid), do: GenServer.call(pid, :decrement)

  # --- Server callbacks: run in the counter's own process ---

  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_call(:increment, _from, count), do: {:reply, count + 1, count + 1}
  def handle_call(:get, _from, count), do: {:reply, count, count}
  def handle_call(:decrement, _from, count), do: {:reply, count - 1, count - 1}

  @impl true
  def handle_cast(:reset, _count), do: {:noreply, 0}

  @impl true
  def handle_info(msg, count) do
    IO.puts("Counter got an unexpected message: #{inspect(msg)}")
    {:noreply, count}
  end
end
```

## Exercise B

### `lib/kv.ex`

```elixir
# A key-value store. The state is a map, for example %{milk: 2, eggs: 6}.
defmodule KV do
  use GenServer

  # --- Client API: runs in the caller's process ---

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def put(pid, key, value) do
    GenServer.call(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def delete(pid, key) do
    GenServer.call(pid, {:delete, key})
  end

  # --- Server callbacks: run in the store's own process ---

  @impl true
  def init(map) do
    {:ok, map}
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
