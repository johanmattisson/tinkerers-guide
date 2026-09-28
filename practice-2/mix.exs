defmodule Practice2.MixProject do
  use Mix.Project

  def project do
    [app: :practice_2, version: "0.1.0", elixir: "~> 1.15", deps: []]
  end

  def application do
    [extra_applications: [:logger, :observer, :wx, :runtime_tools]]
  end
end
