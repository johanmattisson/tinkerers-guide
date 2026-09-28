# Practice 2: Your first GenServer

- **Exercise A**: add one function to the `Counter` from the talk.
- **Exercise B**: build a key-value store.
- **Extras** (optional): for when you are done and want more.

💡 Working in pairs is a great idea.

## Start

```sh
cd practice-2
iex -S mix
```

Then, inside IEx:

```elixir
:observer.start()
```

## Cheat sheet

```elixir
# In the client API (runs in the caller)
GenServer.call(pid, request)    # send a request and wait for the answer
GenServer.cast(pid, request)    # send a request, don't wait

# What the callbacks return (runs in the server)
{:ok, state}                    # from init/1
{:reply, answer, new_state}     # from handle_call/3
{:noreply, new_state}           # from handle_cast/2 and handle_info/2

# Maps
Map.put(map, key, value)        # a new map with the key set
Map.get(map, key)               # the value, or nil if the key is missing
Map.delete(map, key)            # a new map without the key

:sys.get_state(pid)             # look at a GenServer's state
recompile()                     # load your changed files into IEx
```

## If something goes wrong

If you see a big red error and your variables (like `pid`) are gone, **that is normal today**. Your GenServer crashed, and because it was started with `start_link`, it took the shell with it. You will learn why in the last session. Just fix the code, `recompile()`, and start a new one.

---

## Exercise A: Add `decrement`

Open `lib/counter.ex`. This is the `Counter` from the talk.

**1.** Try it:

```elixir
{:ok, pid} = Counter.start_link(10)
Counter.increment(pid)
Counter.get(pid)
```

You should see `11` and `11`.

**2.** Add a `decrement/1` function. You need two things:

- a client function, next to `increment/1`
- a `handle_call` clause for `:decrement`, next to the other `handle_call` clauses

Look at how `increment` is done, and do the same.

**3.** Try it:

```elixir
recompile()
{:ok, pid} = Counter.start_link(10)
Counter.decrement(pid)
```

You should see `9`.

<details>
<summary>Hint</summary>

```elixir
def decrement(pid), do: GenServer.call(pid, :decrement)
```

```elixir
def handle_call(:decrement, _from, count), do: {:reply, count - 1, count - 1}
```

</details>

**4.** Look at the state. In Observer, find your counter in the **Processes** tab and **double-click** it. Open the **State** tab. Or, in IEx:

```elixir
:sys.get_state(pid)
```

---

## Exercise B: A key-value store

Open `lib/kv.ex`. The state is a map, for example `%{milk: 2, eggs: 6}`. `put/3` is already done. You will add `get/2` and `delete/2`.

**1.** Read `put/3`. Find the two parts: the **client function** at the top, and the **`handle_call` clause** at the bottom.

**2.** Try `put`:

```elixir
{:ok, store} = KV.start_link()
KV.put(store, :milk, 2)
:sys.get_state(store)
```

You should see `:ok`, and then `%{milk: 2}`.

**3.** Add `get/2`. It answers with the value, and the state does not change.

```elixir
recompile()
{:ok, store} = KV.start_link()
KV.put(store, :milk, 2)
KV.get(store, :milk)
KV.get(store, :bread)
```

You should see `2`, and then `nil` (there is no bread).

<details>
<summary>Hint 1</summary>

Copy `put`, and change it. The request can be `{:get, key}`. In `handle_call`, use `Map.get(map, key)` as the answer, and keep `map` as the state.

</details>

<details>
<summary>Hint 2</summary>

```elixir
def get(pid, key) do
  GenServer.call(pid, {:get, key})
end
```

```elixir
def handle_call({:get, key}, _from, map) do
  {:reply, Map.get(map, key), map}
end
```

</details>

**4.** Add `delete/2`. It answers `:ok`, and removes the key from the state.

```elixir
KV.delete(store, :milk)
KV.get(store, :milk)
```

You should see `:ok`, and then `nil`.

<details>
<summary>Hint</summary>

Same shape as `put`. Use `Map.delete(map, key)` for the new state.

</details>

**5.** Start a second store, and check that the two stores don't share data:

```elixir
{:ok, other} = KV.start_link()
KV.put(other, :milk, 99)
KV.get(store, :milk)
```

Find both stores in Observer and look at their **State** tab.

🎉 **Done!** You have built a GenServer. In the next session you will give your stores names.

---

## Extras (optional)

**Extra 1: `clear/1` with `cast`.** Add `KV.clear(store)`, which empties the store. Use `GenServer.cast`, not `call`.

```elixir
KV.clear(store)
:sys.get_state(store)
```

You should see `:ok`, and then `%{}`.

<details>
<summary>Hint</summary>

```elixir
def clear(pid) do
  GenServer.cast(pid, :clear)
end
```

```elixir
@impl true
def handle_cast(:clear, _map) do
  {:noreply, %{}}
end
```

</details>

**Extra 2: Unexpected messages.** Send your store a plain message:

```elixir
send(store, :oops)
```

GenServer logs an error for you. Now add your own `handle_info/2` that prints a friendly message instead. In Observer, check that **MsgQ** stays at `0`.

<details>
<summary>Hint</summary>

```elixir
@impl true
def handle_info(msg, map) do
  IO.puts("KV got an unexpected message: #{inspect(msg)}")
  {:noreply, map}
end
```

</details>

---

## Stuck?

Look in `SOLUTION.md`. Try the hints first!
