# Practice 1: Solutions

Try the hints in `README.md` first! Use this file when you are really stuck, or to compare with your own code.

The extras have their solutions in the hints in `README.md`.

## Exercise A

Exercise A has no code to write. Everything is in the steps in `README.md`.

## Exercise B

### `lib/ping_pong.ex`

```elixir
defmodule PingPong do
  def loop do
    receive do
      {:ping, from} ->
        IO.puts("Got a ping from #{inspect(from)}")
        send(from, :pong)
        loop()
    end
  end
end
```

### `lib/shopping_list.ex`

```elixir
defmodule ShoppingList do
  # `items` is the state: a list of everything added so far.
  def loop(items) do
    receive do
      {:add, item} ->
        loop([item | items])

      {:get, from} ->
        send(from, items)
        loop(items)
    end
  end
end
```
