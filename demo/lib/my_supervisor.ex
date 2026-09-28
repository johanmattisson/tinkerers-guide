defmodule MySupervisor do
  def start(children) do
    spawn(fn ->
      Process.flag(:trap_exit, true)

      running = Map.new(children, fn child -> {start_child(child), child} end)
      loop(running)
    end)
  end

  defp start_child({module, arg}) do
    {:ok, pid} = module.start_link(arg)
    pid
  end

  defp loop(running) do
    receive do
      {:EXIT, pid, reason} ->
        IO.puts("#{inspect(pid)} exited with #{inspect(reason)}, restarting")

        {child, running} = Map.pop(running, pid)
        new_pid = start_child(child)
        loop(Map.put(running, new_pid, child))
    end
  end
end
