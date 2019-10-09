defmodule PartyUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      app: :party,
      version: "0.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:horde, "~> 0.7.0"},
      {:libcluster, "~> 3.1"},
      {:faker_elixir_octopus, "~> 1.0.2"},
    ]
  end
end
