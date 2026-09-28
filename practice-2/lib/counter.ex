# This is the Counter from the talk. In Exercise A you add decrement/1 to it.
defmodule Counter do
  use GenServer

  # --- Client API: runs in the caller's process ---

  def start_link(initial \\ 0), do: GenServer.start_link(__MODULE__, initial)
  def increment(pid), do: GenServer.call(pid, :increment)
  def get(pid), do: GenServer.call(pid, :get)
  def reset(pid), do: GenServer.cast(pid, :reset)

  # Step 2: add decrement/1 here.

  # --- Server callbacks: run in the counter's own process ---

  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_call(:increment, _from, count), do: {:reply, count + 1, count + 1}
  def handle_call(:get, _from, count), do: {:reply, count, count}
  # Step 2: add a handle_call clause for :decrement here.

  @impl true
  def handle_cast(:reset, _count), do: {:noreply, 0}

  @impl true
  def handle_info(msg, count) do
    IO.puts("Counter got an unexpected message: #{inspect(msg)}")
    {:noreply, count}
  end
end
