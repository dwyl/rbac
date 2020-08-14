defmodule RbacTest do
  use ExUnit.Case
  doctest Rbac

  test "greets the world" do
    assert Rbac.hello() == :world
  end
end
