defmodule Party.NodeMonitor do
  use GenServer

  def start_link(_init_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(state) do
    :net_kernel.monitor_nodes(true, node_type: :visible)

    {:ok, state}
  end

  defp get_modules() do
    [Party.Supervisor, Party.Registry]
  end

  def handle_info({:nodeup, _node, _node_type}, state) do
    get_modules()
    |> Enum.each(&set_members(&1))

    {:noreply, state}
  end

  def handle_info({:nodedown, _node, _node_type}, state) do
    get_modules()
    |> Enum.each(&set_members(&1))

    {:noreply, state}
  end

  defp set_members(name) do
    [
      :bright, :red, ">>> member list changed <<<"
    ]
    |> IO.ANSI.format()
    |> IO.puts()

    members =
      [Node.self() | Node.list()]
      |> Enum.map(fn node -> {name, node} end)

    :ok = Horde.Cluster.set_members(name, members)
  end
end
