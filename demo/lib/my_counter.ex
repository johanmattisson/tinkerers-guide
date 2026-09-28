defmodule MyCounter do
  # Client API
  def start(initial \\ 0), do: MyServer.start(__MODULE__, initial)
  def increment(pid), do: MyServer.call(pid, :increment)
  def get(pid), do: MyServer.call(pid, :get)

  # Callbacks, called by MyServer inside the server process
  def init(initial), do: {:ok, initial}
  def handle_call(:increment, count), do: {:reply, count + 1, count + 1}
  def handle_call(:get, count), do: {:reply, count, count}
end
