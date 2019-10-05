defmodule BotArmyStarter.Trees.SampleLoad do
  @moduledoc """
  This is a contrived example.  The bots will try up to 5 times to guess the number 
  provided at rutime.  The provided number should be between 1 and 10.

  * `magic_number` - a number for the bots to guess
  """

  import BotArmy.Actions, only: [action: 2, action: 3]
  alias BotArmy.Actions, as: Common
  alias BehaviorTree.Node
  alias BotArmyStarter.Actions.Sample

  @doc """
  Validates the supplied number, then tries to guess it up to 5 times, then sleeps 
  for a minute.
  """
  def tree() do
    # "custom" runtime config is available from `BotArmy.SharedData`
    magic_number = BotArmy.SharedData.get(:magic_number)

    Node.sequence([
      validate_number(magic_number),
      action(Sample, :init_guesses_count),
      # loop here
      Node.repeat_until_succeed(try_to_guess_number(magic_number)),
      # go to "sleep" for a minute before starting over
      action(BotArmy.Actions, :wait, [60])
    ])
  end

  @doc """
  Dies unless the number is valid.
  """
  def validate_number(n) do
    Node.select([
      action(Sample, :validate_number, [n]),
      # note, :error will kill the bot
      action(Common, :error, ["The number must be between 1 and 10"])
    ])
  end

  @doc """
  This tree succeeds either when the bot guesses correctly, or when the bot is out of 
  guesses.  Otherwise it fails.  This is intended for a `repeat_until_succeed` loop.
  """
  def try_to_guess_number(magic_number) do
    Node.select([
      Node.sequence([
        action(Sample, :make_guess),
        action(Common, :wait, [2]),
        action(Sample, :check_guess, [magic_number]),
        action(Common, :log, ["I guessed the number!"])
      ]),
      Node.sequence([
        # negated to fail unless out of guesses 
        Node.negate(action(Sample, :more_guesses_left?, [5])),
        action(Common, :log, ["Failed to guess the number :("])
      ])
    ])
  end
end
