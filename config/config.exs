use Mix.Config

config :libcluster,
  topologies: [
    epmd_example: [
      strategy: Elixir.Cluster.Strategy.Epmd,
      config: [
        hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]]]
