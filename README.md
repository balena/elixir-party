# Let's Party (with Horde)

Exercising to use Horde to simulate a _chat_ room cluster.

![Chat output](https://raw.githubusercontent.com/balena/elixir-party/master/output.png)


## How it works

At start, members of a ficticious chat room are created.

As soon another nodes join the cluster, more members are created.

Case a node dies, existing nodes will handoff the members of that node.


## How to run

Start node `a`:

```
iex --name a@127.0.0.1 -S mix
iex(a@127.0.0.1)1> Party.start()
iex(a@127.0.0.1)2> Party.start_members(3)
```

then on another terminal start node `b`:

```
iex --name b@127.0.0.1 -S mix
iex(b@127.0.0.1)1> Party.start()
iex(b@127.0.0.1)2> Party.start_members(3)
```

Members will start to talk Lorem Ipsum to each other on the screen.

Attempt to kill one of the nodes, the existing one should hand on members of
the killed node.

The reason to not start the "party" as an application is that if you do, the
IEx prompt gets lost. By using as indicated above, the IEx prompt remains
intact as the last line of the screen, and you have ways to explore the app
from it.
