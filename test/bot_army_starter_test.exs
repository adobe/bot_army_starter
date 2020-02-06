defmodule BotArmyStarterTest do
  @moduledoc false

  use TODO

  alias BotArmyStarter.Actions.Sample

  log_to_file()
  use_bot_module(BotArmy.Bot.Default)

  setup do
    %{magic_number: 9}
  end

  pre_tree
  action(BotArmy.Actions, :log, ["Pre..."])

  post_tree
  action(BotArmy.Actions, :log, ["Pre..."])

  # TODO pre_all_tree
  # TODO post_all_tree
  # TODO pre_each_tree
  # TODO post_each_tree
  # TODO run_tree(tree) :: :ok | {:error, reason} function
  # TODO move temp module into bot army
  # TODO update readme in bot army

  # @tag timeout: 6000
  # @tag :verbose
  test_tree "validate target number", context do
    Node.select([
      action(Sample, :validate_number, [context.magic_number]),
      action(BotArmy.Actions, :error, ["#{context.magic_number} is an invalid number"])
    ])
  end

  # TODO
  test "Bots eventually guess correctly" do
    # Warning, this is a recipe for an infinite loop.  In this case we are certain
    # the loop will exit eventually.
    tree =
      Node.sequence([
        action(Sample, :init_guesses_count),
        Node.repeat_until_succeed(
          Node.sequence([
            action(Sample, :make_guess),
            action(Sample, :check_guess, [9])
          ])
        )
      ])

    bot_mod = BotArmy.Bot.Default
    timeout = 5000
    test_name = "test 1"

    Process.flag(:trap_exit, true)
    {:ok, bot_pid} = BotArmy.Bot.start_link(bot_mod, id: test_name)
    :ok = BotArmy.Bot.run(bot_pid, tree_with_done(tree))
    assert_receive {:EXIT, ^bot_pid, :shutdown}, timeout
  end
end
