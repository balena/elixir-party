defmodule Party.Registry do
  use Horde.Registry

  def child_spec(options) do
    options =
      [keys: :unique]
      |> Keyword.merge(options)

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [options]},
    }
  end

  def start_link(init_arg, options \\ []) do
    options =
      [name: __MODULE__]
      |> Keyword.merge(options)

    Horde.Registry.start_link(__MODULE__, init_arg, options)
  end

  def init(init_arg) do
    init_arg =
      [members: get_members()]
      |> Keyword.merge(init_arg)

    Horde.Registry.init(init_arg)
  end

  defp get_members() do
    [Node.self() | Node.list()]
    |> Enum.map(fn node -> {__MODULE__, node} end) 
  end
end
