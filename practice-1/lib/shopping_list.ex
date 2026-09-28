defmodule ShoppingList do
  # `items` is the state: a list of everything added so far.
  def loop(items) do
    receive do
      {:add, item} ->
        loop([item | items])

      # Step 6: add a clause for {:get, from} here.
      # It should send `items` back to `from`, and then keep looping.
    end
  end
end
