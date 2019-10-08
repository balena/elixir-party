defmodule Party.Member do
  use GenServer, restart: :transient, shutdown: 1_000

  defstruct [
   :id,
   :quit,
   :name,
   :app,
   :color,
   :email,
  ]

  def new(opts \\ []) do
    [r, g, b] =
      FakerElixir.Color.make_rgb()
      |> Enum.map(fn c -> (c * 5) |> div(255) end)

    %__MODULE__{
      id: opts |> Keyword.get(:id, 0),
      quit: opts |> Keyword.get(:quit, false),
      name: FakerElixir.Internet.user_name(),
      app: "#{FakerElixir.App.name()}/#{FakerElixir.App.version()}",
      color: IO.ANSI.color(r, g, b),
      email: FakerElixir.Internet.email(),
    }
  end

  def child_spec(opts) do
    member = opts |> Keyword.get(:member, new())

    %{
      id: :"member_#{member.id}",
      start: {Party.Member, :start_link, [member]},
    }
  end

  def start_link(member) do
    GenServer.start_link(__MODULE__, member)
  end

  @impl true
  def init(member) do
    Process.flag(:trap_exit, true)

    member |> join()

    {:ok, member, Enum.random(1_000..10_000)}
  end

  @impl true
  def handle_info(:timeout, member) do
    member |> talk()

    case if member.quit, do: Enum.random(1..10), else: :always do
      1 ->
        member |> quit()
        {:stop, :normal, member}

      _ ->
        {:noreply, member, Enum.random(1_000..10_000)}
    end
  end

  @impl true
  def terminate(reason, member) do
    "!!!"
    |> says([:bright, :red], [
      member.color, member.name, " <", member.email, ">", :reset,
      :bright, :red, " killed, reason: #{inspect reason}",
    ])
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

  defp quit(member) do
    "<--"
    |> says([:bright, :red], [
      member.color, member.name, " <", member.email, ">", :reset,
      :red, :bright, " has quit", :reset, " (", member.app , ")",
    ])
  end

  defp talk(member) do
    member.name
    |> says(member.color, FakerElixir.Lorem.sentence())
  end
end
