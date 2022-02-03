defmodule BorshTest do
  use ExUnit.Case
  doctest Borsh

  test "greets the world" do
    assert Borsh.hello() == :world
  end
end
