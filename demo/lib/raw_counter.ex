defmodule RawCounter do
  # --- Client API: runs in the caller's process ---
  def start(initial \\ 0), do: spawn(fn -> loop(initial) end)

  def increment(pid) do
    send(pid, {:increment, self()})

    receive do
      {:count, n} -> n
    end
  end

  # --- Server: runs in the counter's own process ---
  def loop(count) do
    receive do
      {:increment, from} ->
        send(from, {:count, count + 1})
        loop(count + 1)
    end
  end
end
