defmodule PartyTest do
  use ExUnit.Case
  doctest Party

  test "greets the world" do
    assert Party.hello() == :world
  end
end
