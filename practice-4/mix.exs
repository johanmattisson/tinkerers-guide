defmodule Practice4.MixProject do
  use Mix.Project

  def project do
    [app: :practice_4, version: "0.1.0", elixir: "~> 1.15", deps: []]
  end

  def application do
    [extra_applications: [:logger, :observer, :wx, :runtime_tools], mod: {KV.Application, []}]
  end
end
