# The Tinkerer's Guide to Elixir Processes

Exercise repo for the Goatmire Elixir workshop. Please do the setup below **before** the workshop.

## What you need

- **Erlang/OTP 26 or newer**
- **Elixir 1.15 or newer**
- **Erlang built with wxWidgets.** Observer, the graphical tool we'll use a lot, needs it. See "Troubleshooting Observer" below.
- An editor you're comfortable with. Elixir syntax highlighting is enough. A language server (ElixirLS, Lexical or Expert) is nice to have but not required.

Check your versions:

```sh
elixir --version
```

## 1. Check that iex starts

```sh
iex
```

You should get an `iex(1)>` prompt with no errors.

## 2. Check that Observer runs

In the same `iex` session:

```elixir
:observer.start()
```

A window should open with tabs like *System*, *Load Charts* and *Processes*. Click the **Processes** tab and check that you see a list of processes. Close the window when you're done.

If that works, you're all set! 

**Looking forward to seeing you at the workshop!** :smile: :goat:

---

## Troubleshooting Observer

If `:observer.start()` fails with an error mentioning `wx` or `undef`, your Erlang was built without wxWidgets.

- **macOS (Homebrew):** `brew install erlang elixir` includes wx.
- **asdf / mise:** install wxWidgets before building Erlang (`brew install wxwidgets` on macOS, `libwxgtk3.2-dev` or similar on Linux), then reinstall Erlang.
- **Ubuntu/Debian (apt):** `sudo apt install erlang-observer erlang-wx`
- **Windows:** the official installer includes wx. Under WSL you need WSLg (Windows 11) or an X server for the window to show.

If you get stuck, come by a few minutes early and we'll sort it out together.
