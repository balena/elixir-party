defmodule Party.Application do
  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Party.Supervisor,
      Party.Registry,
      Party.NodeMonitor,
      {Party.ClusterSupervisor, Application.get_env(:libcluster, :topologies)},
    ]

    supervisor =
      Supervisor.start_link(children, strategy: :one_for_one)

    start_members(3)

    supervisor
  end

  defp start_members(0), do: :ok
  defp start_members(i) do
    member = Party.Member.new(silent: false)
    via_tuple = {:via, Horde.Registry, {Party.Registry, member.name, member}}

    spec = Party.Member.child_spec(member: member, name: via_tuple)
    case spec |> Party.Supervisor.start_child() do
      {:ok, _} ->
        start_members(i-1)

      {:error, {:already_started, _}} ->
        Logger.info("Name collision (#{inspect member.name}), trying again")
        start_members(i)
    end
  end
end
