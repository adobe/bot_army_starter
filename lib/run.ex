defmodule BotArmyStarter.Run do
  @moduledoc """
  An entry point to run the bot army (particularly from a mix release)

  Paramerts include:

  (edit these as needed)
  * `magic_number` - a number for the bots to guess
  """
  alias BotArmy.LoadTest

  def run(magic_number) do
    Application.ensure_all_started(:logger)
    Application.ensure_all_started(:bot_army)
    Application.ensure_all_started(:bot_army_starter)

    metadata = [
      :bot_id,
      :action,
      :outcome,
      :error,
      :duration,
      :uptime,
      :bot_pid,
      :session_id,
      :bot_count
    ]

    Logger.configure(level: :warn)

    Logger.add_backend({LoggerFileBackend, :bot_log})

    Logger.configure_backend({LoggerFileBackend, :bot_log},
      path: "bot_run.log",
      level: :debug,
      metadata: metadata
    )

    # do any set up you need...

    # add custom config to BotArmy.SharedData (this is how the mix tasks do it)
    BotArmy.SharedData.put(:magic_number, magic_number)

    LoadTest.run(%{
      # you can parameterize this
      n: 1,
      tree: BotArmyStarter.Trees.SampleLoad.tree(),
      bot: BotArmy.Bot.Default
    })

    # Wait for input before stopping the bots
    IO.gets("\n\n\nPress <enter> to stop the bots\n\n\n")

    BotArmy.Metrics.SummaryReport.build_report()
    BotArmy.LoadTest.stop()
  end
end
