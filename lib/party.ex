defmodule Party do
  require Logger

  def start() do
    children = [
      Party.Supervisor,
      Party.Registry,
      Party.NodeMonitor,
      {Party.ClusterSupervisor, Application.get_env(:libcluster, :topologies)},
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def start_members(0), do: :ok
  def start_members(i) do
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
