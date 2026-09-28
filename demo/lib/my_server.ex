defmodule MyServer do
  def start(module, init_arg) do
    spawn(fn ->
      {:ok, state} = module.init(init_arg)
      loop(module, state)
    end)
  end

  def call(pid, request) do
    ref = make_ref()
    send(pid, {:call, {self(), ref}, request})

    receive do
      {^ref, reply} -> reply
    after
      5_000 -> exit(:timeout)
    end
  end

  defp loop(module, state) do
    receive do
      {:call, {from, ref}, request} ->
        {:reply, reply, new_state} = module.handle_call(request, state)
        send(from, {ref, reply})
        loop(module, new_state)
    end
  end
end
