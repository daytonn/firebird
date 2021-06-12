defmodule FirebirdTest do
  use ExUnit.Case
  doctest Firebird

  test "greets the world" do
    assert Firebird.hello() == :world
  end
end
