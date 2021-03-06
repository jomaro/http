defmodule Http.MixProject do
  use Mix.Project

  def project do
    [
      app: :http,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:finch, "~> 0.8"},
      {:castore, "~> 0.1.0"},
      {:mint, "~> 1.0"},

      {:jason, "~> 1.2"},

      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
    ]
  end
end
