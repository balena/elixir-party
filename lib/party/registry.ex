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

  def count() do
    Horde.Registry.count(__MODULE__)
  end

  def count_match(key, pattern, guards \\ []) do
    Horde.Registry.count_match(__MODULE__, key, pattern, guards)
  end

  def dispatch(key, mfa_or_fun, opts \\ []) do
    Horde.Registry.dispatch(__MODULE__, key, mfa_or_fun, opts)
  end

  def keys(pid) do
    Horde.Registry.keys(__MODULE__, pid)
  end

  def lookup(key) do
    Horde.Registry.lookup(__MODULE__, key)
  end

  def match(key, pattern, guards \\ []) do
    Horde.Registry.match(__MODULE__, key, pattern, guards)
  end

  def meta(key) do
    Horde.Registry.meta(__MODULE__, key)
  end

  def put_meta(key, value) do
    Horde.Registry.put_meta(__MODULE__, key, value)
  end

  def register(name, value) do
    Horde.Registry.register(__MODULE__, name, value)
  end

  def select(spec) do
    Horde.Registry.select(__MODULE__, spec)
  end

  def unregister(name) do
    Horde.Registry.unregister(__MODULE__, name)
  end

  def unregister_match(key, pattern, guards \\ []) do
    Horde.Registry.unregister_match(__MODULE__, key, pattern, guards)
  end

  def update_value(key, callback) do
    Horde.Registry.update_value(__MODULE__, key, callback)
  end
end
