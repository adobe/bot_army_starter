defmodule BotArmyStarter do
  use ExUnit.Case
  doctest BotDemo

  test "greets the world" do
    assert BotArmyStarter.hello() == :world
  end
end
