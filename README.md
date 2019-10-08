# Party

Exercising to use Horde to simulate a _chat_ room cluster.

## How it works

At start, members of a ficticious chat room are created.

As soon another nodes join the cluster, more members are created.

Case a node dies, existing nodes will handoff the members of that node.

## How to run

Start node `a`:

```
iex --name a@127.0.0.1 -S mix
```

then on another terminal start node `b`:

```
iex --name b@127.0.0.1 -S mix
```

Members will start to talk Lorem Ipsum to each other on the screen.

Attempt to kill one of the nodes, the existing one should hand on members of
the killed node.

