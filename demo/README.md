# Demo project for Sections 2–4

```sh
cd demo
iex -S mix
```

```elixir
:observer.start()
```

Section 1 does **not** run here. Use a plain `iex` session for it. This project has its own `Counter` module, and the app starts `Demo.Registry` at boot. Switch to this project during Practice 1.

## Files per section

| Section | File | Used in |
|---|---|---|
| 2 | `lib/raw_counter.ex` | beats 0–1 |
| 2 | `lib/my_server.ex`, `lib/my_counter.ex` | beat 2 |
| 2 | `lib/counter.ex` | beats 3–5 |
| 3 | `lib/demo/application.ex` | beat 2 (starts `Demo.Registry`) |
| 3 | `lib/named_counter.ex` | beat 4 onwards |
| 4 | `lib/my_supervisor.ex` | beat 4 |
| 4 | `lib/demo/counter_supervisor.ex` | beat 5 (started at runtime with `Supervisor.start_child/2`) |
| 4 | `lib/sys_counter.ex` | optional extra |

`mix.exs` lists `:observer`, `:wx` and `:runtime_tools` in `extra_applications`. Without them, `:observer.start()` is undefined under `iex -S mix`.
