# Optional extra for Section 4, rule two of "OTP compliant".
defmodule SysCounter do
  # --- Client API ---
  def start(initial \\ 0) do
    parent = self()
    :proc_lib.spawn(fn -> loop(initial, parent, []) end)
  end

  def increment(pid) do
    ref = make_ref()
    send(pid, {:increment, {self(), ref}})

    receive do
      {^ref, n} -> n
    after
      5_000 -> exit(:timeout)
    end
  end

  # --- Server loop ---
  defp loop(count, parent, debug) do
    receive do
      {:increment, {from, ref}} ->
        send(from, {ref, count + 1})
        loop(count + 1, parent, debug)

      {:system, from, request} ->
        :sys.handle_system_msg(request, from, parent, __MODULE__, debug, count)
    end
  end

  # --- :sys callbacks ---
  def system_continue(parent, debug, count), do: loop(count, parent, debug)
  def system_terminate(reason, _parent, _debug, _count), do: exit(reason)
  def system_get_state(count), do: {:ok, count}

  def system_replace_state(fun, count) do
    new_count = fun.(count)
    {:ok, new_count, new_count}
  end
end
