defmodule Party.Supervisor do
  use Horde.DynamicSupervisor

  def start_link(init_arg, options \\ []) do
    options =
      [name: __MODULE__]
      |> Keyword.merge(options)
    Horde.DynamicSupervisor.start_link(__MODULE__, init_arg, options)
  end

  def init(init_arg) do
    [strategy: :one_for_one, members: get_members()]
    |> Keyword.merge(init_arg)
    |> Horde.DynamicSupervisor.init()
  end

  defp get_members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {__MODULE__, node} end)
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
