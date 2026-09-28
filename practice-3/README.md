# Practice 3: Find processes by name

- **Exercise A**: names and the Registry, in IEx.
- **Exercise B**: make your key-value store findable by name.
- **Extras** (optional): for when you are done and want more.

💡 Working in pairs is a great idea.

## Start

```sh
cd practice-3
iex -S mix
```

Then, inside IEx:

```elixir
:observer.start()
```

**The file you work in is `lib/kv.ex`.** It already has a working key-value store from Practice 2, so you are not stuck if yours didn't work. The Registry, `KV.Registry`, is already started for you in `lib/kv/application.ex`. You don't need to change that file.

## Cheat sheet

```elixir
Process.register(pid, :some_atom)            # give a process an atom name
Registry.register(KV.Registry, key, value)   # register the CALLING process under key
Registry.lookup(KV.Registry, key)            # [{pid, value}] or []
recompile()                                  # load your changed files into IEx
```

## If something goes wrong

If you see a big red error and your variables are gone, **that is normal today**. A process linked to the shell crashed and took the shell with it. You will learn why in the last session. Just fix the code, `recompile()`, and start again.

⚠️ Don't start two stores with the same name. The second one fails to start, and it takes the shell with it.

---

## Exercise A: Names

**1.** Find the Registry in Observer. Go to the **Applications** tab and click `practice_3`. You should see `KV.Registry` in the tree.

**2.** Give a store an atom name:

```elixir
{:ok, pid} = KV.start_link()
Process.register(pid, :my_store)
KV.put(:my_store, :milk, 2)
KV.get(:my_store, :milk)
```

You should see `:ok` and `2`. In Observer's **Processes** tab, look at the **Name** column. It says `my_store`.

**3.** Register the shell in the Registry, and look it up:

```elixir
Registry.register(KV.Registry, "shell", nil)
Registry.lookup(KV.Registry, "shell")
self()
```

The PID from `lookup` is the same as `self()`. `register` always registers the process that calls it.

**4.** Start a process that registers itself, and then waits:

```elixir
worker = spawn(fn ->
  Registry.register(KV.Registry, "worker", nil)

  receive do
    :stop -> :ok
  end
end)

Registry.lookup(KV.Registry, "worker")
```

You should see a list with one `{pid, nil}` in it.

**5.** Stop it, and look again:

```elixir
send(worker, :stop)
Registry.lookup(KV.Registry, "worker")
```

You should see `[]`. The name is gone, because the process is gone.

---

## Exercise B: A store you find by name

The goal: you start a store with a name, like `"groceries"`, and then you only use that name.

```elixir
KV.start_link("groceries")
KV.put("groceries", :milk, 2)
KV.get("groceries", :milk)
```

**1.** Open `lib/kv.ex`. Read `whereis/1`. It is already done. It turns a name into a PID, or `nil`.

**2.** Change `start_link` so it takes a `name`, and passes the name on to `init`.

<details>
<summary>Hint</summary>

```elixir
def start_link(name) do
  GenServer.start_link(__MODULE__, name)
end
```

</details>

**3.** Change `init`. It gets the name. It should register the name in `KV.Registry`, and start with an empty map as the state.

Why in `init`? `init` runs **inside** the new store process. So when it calls `Registry.register`, it registers **itself**.

<details>
<summary>Hint</summary>

```elixir
@impl true
def init(name) do
  {:ok, _owner} = Registry.register(@registry, name, nil)
  {:ok, %{}}
end
```

</details>

**4.** Change `put`, `get` and `delete`. They take a `name` instead of a `pid`, and use `whereis(name)` to find the PID.

<details>
<summary>Hint</summary>

```elixir
def put(name, key, value) do
  GenServer.call(whereis(name), {:put, key, value})
end
```

`get` and `delete` look the same.

</details>

**5.** Try it:

```elixir
recompile()
KV.start_link("groceries")
KV.start_link("todo")

KV.put("groceries", :milk, 2)
KV.put("todo", :laundry, true)

KV.get("groceries", :milk)
KV.get("todo", :milk)
```

You should see `2`, and then `nil`. Two stores, two names, no shared data.

**6.** Find your stores in Observer. The **Name** column is empty, because the Registry holds the names, not the processes. Ask the Registry first:

```elixir
KV.whereis("groceries")
```

Find that PID in the **Processes** tab, double-click it, and look at the **State** tab.

🎉 **Done!** Your stores have names. In the next session you will make them come back when they crash.

---

## Extras (optional)

**Extra 1: A missing store.** What happens now?

```elixir
KV.get("nope", :milk)
```

It crashes, because `whereis` returns `nil`. Change `get` so it returns `{:error, :not_found}` instead. Then do the same for `put` and `delete`.

<details>
<summary>Hint</summary>

```elixir
def get(name, key) do
  case whereis(name) do
    nil -> {:error, :not_found}
    pid -> GenServer.call(pid, {:get, key})
  end
end
```

</details>

**Extra 2: Store something in the Registry.** Each entry has a value next to the PID. Right now it is `nil`. Store the time the store started, with `DateTime.utc_now()`. Then write `KV.started_at(name)`, which reads it back with `Registry.lookup`.

<details>
<summary>Hint</summary>

In `init`:

```elixir
{:ok, _owner} = Registry.register(@registry, name, DateTime.utc_now())
```

And a new function:

```elixir
def started_at(name) do
  case Registry.lookup(@registry, name) do
    [{_pid, time}] -> time
    [] -> {:error, :not_found}
  end
end
```

</details>

---

## Stuck?

Look in `SOLUTION.md`. Try the hints first!
