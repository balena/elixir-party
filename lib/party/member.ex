defmodule Party.Member do
  use GenServer

  defstruct [
   :silent,
   :name,
   :app,
   :color,
   :email,
  ]

  def new(opts \\ []) do
    [r, g, b] =
      FakerElixir.Color.make_rgb()
      |> Enum.map(fn c -> (c * 5) |> div(255) end)

    name = FakerElixir.Internet.user_name()

    %__MODULE__{
      silent: opts |> Keyword.get(:silent, false),
      name: name,
      app: "#{FakerElixir.App.name()}/#{FakerElixir.App.version()}",
      color: IO.ANSI.color(r, g, b),
      email: FakerElixir.Internet.email(),
    }
  end

  def quit(server), do: GenServer.call(server, :quit)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {Party.Member, :start_link, [opts]},
      restart: :temporary,
      shutdown: 1_000,
    }
  end

  def start_link(options) do
    member = options |> Keyword.fetch!(:member)
    options = options |> Keyword.delete(:member)
    GenServer.start_link(__MODULE__, member, options)
  end

  @impl true
  def init(member) do
    Process.flag(:trap_exit, true)

    member |> join()

    {:ok, member, Enum.random(1_000..10_000)}
  end

  @impl true
  def handle_call(:quit, _from, member) do
    member |> do_quit()

    {:stop, :normal, :ok, member}
  end

  @impl true
  def handle_info(:timeout, member) do
    member |> talk()
    {:noreply, member, Enum.random(1_000..10_000)}
  end

  @impl true
  def terminate(reason, member) do
    if reason != :normal do
      "!!!"
      |> says([:bright, :red], [
        member.color, member.name, " <", member.email, ">", :reset,
        :bright, :red, " killed, reason: #{inspect reason}",
      ])
    end
  end

  defp says(who, color, text) do
    %{hour: h, minute: m, second: s} = Time.utc_now()
    time =
      [h, m, s]
      |> Enum.map(fn x ->
        x
        |> Integer.to_string()
        |> String.pad_leading(2, "0")
      end)
      |> Enum.join(":")

    [
      time, " ", color, who |> String.pad_leading(20, " "), :reset,
      :bright, " | ", :reset, text
    ]
    |> IO.ANSI.format()
    |> IO.puts()
  end

  defp join(member) do
    "-->"
    |> says([:bright, :green], [
      member.color, member.name, " <", member.email, ">", :reset,
      :green, :bright, " has joined", :reset, " (", member.app , ")",
    ])
  end

  defp do_quit(member) do
    "<--"
    |> says([:bright, :red], [
      member.color, member.name, " <", member.email, ">", :reset,
      :red, :bright, " has quit", :reset, " (", member.app , ")",
    ])
  end

  defp talk(member) do
    if not member.silent do
      member.name
      |> says(member.color, FakerElixir.Lorem.sentence())
    end
  end
end
