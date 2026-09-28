# This file starts as the Practice 2 reference solution, plus a ready-made
# whereis/1. It's here so you're not stuck if yours didn't work.
# In Exercise B you change it, so stores are found by name instead of PID.
defmodule KV do
  use GenServer

  @registry KV.Registry

  # --- Client API: runs in the caller's process ---

  # Step 2: change start_link to take a name.
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  # Step 4: change put, get and delete to take a name instead of a pid.
  def put(pid, key, value) do
    GenServer.call(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def delete(pid, key) do
    GenServer.call(pid, {:delete, key})
  end

  # Turns a name into a pid. Returns nil if no store has that name.
  def whereis(name) do
    case Registry.lookup(@registry, name) do
      [{pid, _value}] -> pid
      [] -> nil
    end
  end

  # --- Server callbacks: run in the store's own process ---

  # Step 3: register the name here, and start with an empty map.
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
