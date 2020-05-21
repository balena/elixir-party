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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:horde, github: "derekkraan/horde", tag: "381279cc2a72b5f16a91a6bdca3a4cb1fa166953"},
      {:libcluster, "~> 3.1"},
      {:faker_elixir_octopus, "~> 1.0.2"}
    ]
  end
end
