defmodule PingPong do
  def loop do
    receive do
      {:ping, from} ->
        IO.puts("Got a ping from #{inspect(from)}")
        # Step 2: send :pong back to `from` here.
        # Step 3: call loop() here, so the process keeps running.
    end
  end
end
