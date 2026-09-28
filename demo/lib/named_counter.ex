defmodule NamedCounter do
  use GenServer

  @registry Demo.Registry

  # --- Client API: callers only ever deal with the name ---
  def start_link(name), do: GenServer.start_link(__MODULE__, name)

  def increment(name), do: GenServer.call(whereis(name), :increment)
  def get(name), do: GenServer.call(whereis(name), :get)

  def whereis(name) do
    case Registry.lookup(@registry, name) do
      [{pid, _value}] -> pid
      [] -> nil
    end
  end

  # --- Server callbacks ---
  @impl true
  def init(name) do
    {:ok, _owner} = Registry.register(@registry, name, nil)
    {:ok, 0}
  end

  @impl true
  def handle_call(:increment, _from, count), do: {:reply, count + 1, count + 1}
  def handle_call(:get, _from, count), do: {:reply, count, count}
end
