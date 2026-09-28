# Practice 1: Your first processes

- **Exercise A**: do what you saw in the talk.
- **Exercise B**: write a process that stays alive and remembers things.
- **Extras** (optional): for when you are done and want more.

💡 Working in pairs is a great idea.

## Start

```sh
cd practice-1
iex -S mix
```

Then, inside IEx:

```elixir
:observer.start()
```

## Cheat sheet

```elixir
self()                  # the PID of the current process
spawn(fn -> ... end)    # start a new process, returns its PID
send(pid, message)      # put a message in a process's mailbox
Process.alive?(pid)     # true or false
flush()                 # show (and remove) all messages in the shell's mailbox
recompile()             # load your changed files into IEx
[item | items]          # a new list with `item` at the front
```

---

## Exercise A: Spawn and look

**1.** Find the PID of your shell:

```elixir
self()
```

You should see something like `#PID<0.110.0>`.

**2.** Start a process that prints something and stops:

```elixir
pid = spawn(fn -> IO.puts("Hi from #{inspect(self())}") end)
Process.alive?(pid)
```

You should see the message, and then `false`. The process is already done.

**3.** Start a process that waits for a message:

```elixir
pid = spawn(fn ->
  receive do
    msg -> IO.puts("Got: #{inspect(msg)}")
  end
end)

Process.alive?(pid)
```

This time you should see `true`. The process is waiting.

**4.** Find your process in Observer. Go to the **Processes** tab and click the **Pid** column header to sort. Your process has one of the highest numbers.

**5.** Send it a message:

```elixir
send(pid, :hello)
Process.alive?(pid)
```

You should see `Got: :hello`, and then `false`.

---

## Exercise B: A process that stays alive

Open `lib/ping_pong.ex`.

**1.** Try the file as it is:

```elixir
pid = spawn(&PingPong.loop/0)
send(pid, {:ping, self()})
Process.alive?(pid)
```

It prints a message, and then the process is gone (`false`).

**2.** Make it answer. In `lib/ping_pong.ex`, send `:pong` back to `from`. Then:

```elixir
recompile()
pid = spawn(&PingPong.loop/0)
send(pid, {:ping, self()})
flush()
```

You should see `:pong`.

⚠️ After `recompile()`, always start a **new** process. Old processes still run the old code.

<details>
<summary>Hint</summary>

`from` is the PID of whoever sent the ping. Use `send(from, :pong)`.

</details>

**3.** Keep it alive. Call `loop()` again after sending the answer. Then `recompile()`, start a new process, and send it **two** pings:

```elixir
send(pid, {:ping, self()})
send(pid, {:ping, self()})
flush()
Process.alive?(pid)
```

You should see `:pong` two times, and then `true`.

<details>
<summary>Hint</summary>

The last line inside the `{:ping, from} ->` clause should be `loop()`. The function calls itself, so it waits for the next message.

</details>

**4.** Find your process in Observer. It is still there, because it never finishes.

**5.** Now a process that **remembers** things. Open `lib/shopping_list.ex`. The list of items is passed along each time `loop` calls itself. Try it:

```elixir
pid = spawn(fn -> ShoppingList.loop([]) end)
send(pid, {:add, "milk"})
send(pid, {:add, "eggs"})
```

It works, but there is no way to see the list yet.

**6.** Add a `{:get, from}` clause. It sends `items` back to `from`, and then keeps looping with the same items.

**7.** Try it (remember: `recompile()` and start a new process first):

```elixir
send(pid, {:add, "milk"})
send(pid, {:add, "eggs"})
send(pid, {:get, self()})
flush()
```

You should see `["eggs", "milk"]`. The newest item is first, because `[item | items]` adds to the front.

<details>
<summary>Hint</summary>

It looks a lot like the `{:add, item}` clause:

```elixir
{:get, from} ->
  send(from, items)
  loop(items)
```

</details>

🎉 **Done!** You have written a process that lives forever and holds state. Next session you will see a better way to write this.

---

## Extras (optional)

**Extra 1: Don't wait forever.** Write a process in IEx that waits for a message. If nothing comes within 5 seconds, it prints `Nobody wrote to me` and stops.

<details>
<summary>Hint</summary>

`receive` can have an `after` part:

```elixir
spawn(fn ->
  receive do
    msg -> IO.puts("Got: #{inspect(msg)}")
  after
    5_000 -> IO.puts("Nobody wrote to me")
  end
end)
```

</details>

**Extra 2: How cheap are processes?** Go to Observer's **System** tab (stay there, the Processes tab gets slow with this many). Then start 100,000 processes that just wait:

```elixir
pids = for _ <- 1..100_000, do: spawn(fn -> receive do :stop -> :ok end end)
```

Look at the **Processes** number in the System tab, and at the **Load Charts** tab. How much memory did it take? Then stop them all again:

```elixir
Enum.each(pids, fn pid -> send(pid, :stop) end)
```

---

## Stuck?

Look in `SOLUTION.md`. Try the hints first!
