# Bot Army Starting Template

A starting point for setting up a new bot army. This includes samples for both load
testing and integration/functional testing.

See [Bot Army Docs](https://hexdocs.pm/bot_army/1.0.0/readme.html) on how to use the
bot army.

The [Bot Army Cookbook](https://github.com/adobe/bot_army_cookbook) is also useful.

## Set up

You will need to have Elixir and Erlang installed on your computer/container
([asdf](https://github.com/asdf-vm/asdf-elixir) works well for this).

Fetch and compile deps with `mix do deps.get, deps.compile`.

If you want to write your tests in the same repo as the project they are testing, you
can `mv bot_army_starter your_project/bot_test`.

## Using

The behavior trees are located in `/lib/trees` and the actions are in `/lib/actions`.

The sample load tree imports tree data from a json file created with the [Behavior
Tree Visual Editor](https://github.com/adobe/behavior_tree_editor).
Download the editor from there and open `./lib/trees/sample_load_bt.json` to view and
edit the tree.

Follow the examples and the docs to build out your trees and actions. You may also
need to add a `/lib/bot.ex` module if you need to [customize the
bot](https://hexdocs.pm/bot_army/1.0.0/BotArmy.Bot.html#module-extending-the-bot)
(to add websocket syncing for example).

Keep your actions atomic, and use the structure of the trees to describe the logic of
your behaviors.

## Running locally

You can run the bots locally using the two included mix tasks:

### Load test runner

`mix bots.load_test --tree BotArmyStarter.Trees.SampleLoad --n 5 --custom '[magic_number: 7]'`

You will see some output. Press "q" then "enter" to quit the bots and see a summary
of their actions. You can view the full logs at `bot_run.log`.

For convenience, the above command can also be run with `sh lib/trees/run_load.sh`
(edit that file to change parameters).

### Integration test runner

`mix test`

This will run all of the integration tests in `test/` via ExUnit.

## Deploying

You can run the bots in a docker container. A sample docker file is provided, but
you will need to adjust it (particularly the `CMD` section).

You can also build a "release" which can be run as an executable. _Be aware the
release can only run on the same OS it was built on!_

Just run `mix release`, which will build it to
`_build/prod/rel/bot_army_starter/bin/bot_army_starter`.

To run it `cd _build/prod/rel/bot_army_starter/` and then run `bin/bot_test eval 'BotArmyStarter.Run.run(30)'` (See `lib/run.ex`).
