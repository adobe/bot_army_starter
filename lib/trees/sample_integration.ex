defmodule BotArmyStarter.Trees.SampleIntegration do
  @moduledoc """
  This is a contrived example.  It does some various "validations" using the same 
  actions as the load test.

  Each test (including pre/post) runs in its own bot.
  """

  import BotArmy.Actions, only: [action: 2, action: 3]
  alias BotArmy.Actions, as: Common
  alias BehaviorTree.Node
  alias BotArmyStarter.Actions.Sample

  use BotArmy.IntegrationTest.Workflow

  pre(action(Sample, :validate_number, [BotArmy.SharedData.get(:magic_number)]))

  parallel "Bots correctly track guess count" do
    Node.sequence([
      action(Sample, :init_guesses_count),
      Node.repeat_n(5, action(Sample, :make_guess)),
      action(Sample, :validate_guess_count, [5])
    ])
  end

  parallel "Bots eventually guess correctly" do
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
end
