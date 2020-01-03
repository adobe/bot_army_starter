defmodule BotArmyStarter.Trees.SampleLoad do
  @moduledoc """
  This is a contrived example.  The bots will try up to 5 times to guess the number
  provided at rutime.  The provided number should be between 1 and 10.

  * `magic_number` - a number for the bots to guess
  """

  @doc """
  Validates the supplied number, then tries to guess it up to 5 times, then sleeps
  for a minute.

  This uses the visual behavior tree editor
  (https://git.corp.adobe.com/BotTestingFramework/behavior_tree_editor) to define the
  tree (which strips the custom action prefix BotArmyStarter.Actions, so it is added
  back in).
  """
  def tree() do
    # "custom" runtime config is available from `BotArmy.SharedData`
    magic_number = BotArmy.SharedData.get(:magic_number)

    BotArmy.BTParser.parse!("lib/trees/sample_load_bt.json",
      context: %{magic_number: magic_number},
      module_base: BotArmyStarter.Actions
    )
  end
end
