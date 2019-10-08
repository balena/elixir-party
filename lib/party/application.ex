defmodule Party.Application do
  use Application

  def start(_type, _args) do
    children = [
      Party.Supervisor,
      Party.Registry,
      Party.NodeMonitor,
      {Party.ClusterSupervisor, Application.get_env(:libcluster, :topologies)},
    ]

    supervisor =
      Supervisor.start_link(children, strategy: :one_for_one)

    1..3  # start members
    |> Enum.each(fn i ->
      Party.Member.child_spec(id: i, quit: false)
      |> Party.Supervisor.start_child()
    end)

    supervisor
  end
end
