# Practice 4: Let it crash

- **Exercise A**: links and crashes, in IEx.
- **Exercise B**: put your stores under a supervisor, crash one, and watch it come back.
- **Extras** (optional): for when you are done and want more.

💡 Working in pairs is a great idea.

## Start

```sh
cd practice-4
iex -S mix
```

Then, inside IEx:

```elixir
:observer.start()
```

**The files you work in are `lib/kv/store_supervisor.ex` and `lib/kv/application.ex`.** `lib/kv.ex` is a working, name-based store from Practice 3, so you are not stuck if yours didn't work. You don't need to change it.

## Cheat sheet

```elixir
spawn_link(fn -> ... end)            # spawn, plus a link to the new process
Process.flag(:trap_exit, true)       # turn exit signals into {:EXIT, pid, reason} messages
Process.exit(pid, :kill)             # kill a process
Supervisor.which_children(name)      # list a supervisor's children
flush()                              # show (and remove) all messages in the shell's mailbox
```

**Quit IEx:** press `Ctrl+C` two times (or type `System.halt()`). Changes to `application.ex` only work after you start IEx again. Remember to start Observer again too.

---

## Exercise A: Links

**1.** A crash without a link:

```elixir
self()
spawn(fn -> raise "boom" end)
self()
```

You see a red error, but the shell has the **same** PID before and after. Nobody cared about the crash.

**2.** A crash with a link. First, start a store from the shell:

```elixir
KV.start_link("test")
KV.whereis("test")
```

Now crash a linked process:

```elixir
spawn_link(fn -> raise "boom" end)
self()
KV.whereis("test")
```

The shell has a **new** PID. And `"test"` is `nil`. The crash went to the shell, and from the shell to the store. Links go both ways.

**3.** Trap exits, so a crash becomes a message:

```elixir
Process.flag(:trap_exit, true)
spawn_link(fn -> raise "boom" end)
self()
flush()
```

This time the shell survives (same PID). `flush()` shows an `{:EXIT, pid, reason}` message.

**4.** Turn it off again:

```elixir
Process.flag(:trap_exit, false)
```

---

## Exercise B: A supervisor for your stores

**1.** Open `lib/kv/store_supervisor.ex` and `lib/kv/application.ex`. Read them. The children list in `store_supervisor.ex` is empty.

**2.** In `store_supervisor.ex`, add a store called `"groceries"` to the children list.

<details>
<summary>Hint</summary>

`{KV, "groceries"}` means: start it with `KV.start_link("groceries")`.

```elixir
children = [
  {KV, "groceries"}
]
```

</details>

**3.** In `application.ex`, add `KV.StoreSupervisor` to the children list, **after** the Registry. Don't forget the comma!

<details>
<summary>Why after?</summary>

Children start from top to bottom. Each store registers itself in the Registry when it starts. So the Registry must already be running.

</details>

**4.** Quit IEx and start it again. Then:

```elixir
KV.put("groceries", :milk, 2)
KV.get("groceries", :milk)
```

You should see `:ok` and `2`. You didn't start the store yourself. The application did it for you.

**5.** Add a second store, `"todo"`, to the children list. Quit IEx and start it again.

IEx doesn't start! Read the error. It says more than one child has the id `KV`. Every child needs its own id.

<details>
<summary>Hint</summary>

Use `Supervisor.child_spec/2` to give each child its own id:

```elixir
children = [
  Supervisor.child_spec({KV, "groceries"}, id: :groceries),
  Supervisor.child_spec({KV, "todo"}, id: :todo)
]
```

</details>

**6.** Fix it, and start IEx again. Check both stores:

```elixir
KV.put("groceries", :milk, 2)
KV.put("todo", :laundry, true)
Supervisor.which_children(KV.StoreSupervisor)
```

In Observer, go to the **Applications** tab and click `practice_4`. You see your supervision tree: `KV.Supervisor` at the top, then the Registry and `KV.StoreSupervisor`, and your two stores under it.

**7.** Now crash a store on purpose. First, remember some PIDs:

```elixir
self()
KV.whereis("groceries")
```

Kill the groceries store. In Observer's **Applications** tab, **right-click** the store and choose **Kill process**. Or, in IEx:

```elixir
Process.exit(KV.whereis("groceries"), :kill)
```

**8.** Check what happened:

```elixir
KV.whereis("groceries")
KV.get("groceries", :milk)
self()
```

- `"groceries"` has a **new** PID. The supervisor started a new store, and it registered the same name again.
- The milk is gone (`nil`). A new store starts from `init`, with an empty map.
- The shell has the **same** PID. It was not linked to the store, so it didn't crash.

In Observer, the tree shows the new PID.

🎉 **Done!** A GenServer with state, a Registry for names, and a Supervisor that brings it back.

---

## Extras (optional)

**Extra 1: Wrong order.** In `application.ex`, move `KV.StoreSupervisor` **before** the Registry. Start IEx again. What happens, and why? Then move it back.

<details>
<summary>Answer</summary>

IEx doesn't start. The error says `unknown registry: KV.Registry`. The stores start first, and they try to register in a Registry that doesn't exist yet.

</details>

**Extra 2: Too many crashes.** Kill the groceries store four times, quickly:

```elixir
KV.put("todo", :laundry, true)
KV.whereis("todo")

for _ <- 1..4 do
  Process.exit(KV.whereis("groceries"), :kill)
  Process.sleep(100)
end

KV.whereis("todo")
KV.get("todo", :laundry)
```

You never touched `"todo"`. Why does it have a new PID, and why is its data gone?

<details>
<summary>Answer</summary>

A supervisor only restarts a child **3 times in 5 seconds** (by default). After that it thinks something is badly wrong and gives up: it stops itself and all its children, so `"todo"` stops too. Then `KV.Supervisor`, one level up, sees that `KV.StoreSupervisor` stopped, and starts it again, with fresh stores.

</details>

**Something to think about (no code):** a restarted store is always empty. Where could the data live, so it survives a crash?

---

## Stuck?

Look in `SOLUTION.md`. Try the hints first!
