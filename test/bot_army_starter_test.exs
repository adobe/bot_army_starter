defmodule BotArmyStarterTest do
  @moduledoc false

  use BotArmy.IntegrationTest

  alias BotArmyStarter.Actions.Sample

  log_to_file()
  use_bot_module(BotArmy.Bot.Default)

  setup do
    %{magic_number: 9}
  end

  pre_all_tree "pre all" do
    Node.sequence([action(BotArmy.Actions, :log, ["Pre all ..."])])
  end

  post_all_tree "post all" do
    BehaviorTree.Node.sequence([action(BotArmy.Actions, :log, ["Post all ..."])])
  end

  # @tag :verbose
  test_tree "validate target number", context do
    Node.select([
      action(Sample, :validate_number, [context.magic_number]),
      action(BotArmy.Actions, :error, ["#{context.magic_number} is an invalid number"])
    ])
  end

  # You can skip it if you want, see ExUnit.Case docs
  # @tag :skip
  test_tree "Bots eventually guess correctly" do
    # Warning, this is a recipe for an infinite loop.  In this case we are certain
    # the loop will exit eventually.
    Node.sequence([
      action(Sample, :init_guesses_count),
      Node.repeat_until_succeed(
        Node.sequence([
          action(Sample, :make_guess),
          action(Sample, :check_guess, [9])
        ])
      )
    ])
  end

  test_tree "validate target number using bt.json subtree", %{magic_number: magic_number} do
    BotArmy.BTParser.parse!(
      "lib/trees/sample_load_bt.json",
      "validate_number",
      context: %{magic_number: magic_number},
      module_base: BotArmyStarter.Actions
    )
  end
end
