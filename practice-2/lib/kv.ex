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

  # Step 3: add get/2 here.

  # Step 4: add delete/2 here.

  # --- Server callbacks: run in the store's own process ---

  @impl true
  def init(map) do
    {:ok, map}
  end

  @impl true
  def handle_call({:put, key, value}, _from, map) do
    {:reply, :ok, Map.put(map, key, value)}
  end

  # Step 3: add a handle_call clause for {:get, key} here.

  # Step 4: add a handle_call clause for {:delete, key} here.
end
