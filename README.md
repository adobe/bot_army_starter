### Bot Army Starter

A starting point for setting up a new bot army.  This includes samples for both load 
testing and integration/functional testing.

See [Bot Army Docs](https://git.corp.adobe.com/pages/manticore/bot_army/readme.html) 
on how to use the bot army.

The [Bot Army 
Cookbook](https://git.corp.adobe.com/pages/manticore/bot_army_cookbook/) is also 
useful.

### Set up

You will need to have Elixir and Erlang installed on your computer/container 
([asdf](https://github.com/asdf-vm/asdf-elixir) works well for this).

The `bot_army` dependency is managed via git submodules (since Elixir's dependency 
management tool can't easily access our corp Github, especially in a docker 
container).

You can clone the repo and set up the submodules with `git clone --recurse-submodules 
git@git.corp.adobe.com:manticore/bot_army_starter.git`.

(Alternatively, you can clone the repo like usual and run `git submodule init && git 
submodule update`.)

Then fetch and compile deps with `mix do deps.get, deps.compile`.

If you want to write your tests in the same repo as the project they are testing, you 
can `mv bot_army_starter your_project/bot_test`.

### Using

The behavior trees are located in `/lib/trees` and the actions are in `/lib/actions`.

Follow the examples and the docs to build out your trees and actions.  You may also 
need to add a `/lib/bot.ex` module if you need to [customize the 
bot](https://git.corp.adobe.com/pages/manticore/bot_army/BotArmy.Bot.html#module-extending-the-bot) 
(to add websocket syncing for example).

Keep your actions atomic, and use the structure of the trees to describe the logic of 
your behaviors.

### Running locally

You can run the bots locally using the two included mix tasks:

#### Load test runner

`mix bots.load_test --tree BotArmyStarter.Trees.SampleLoad --n 5 --custom 
'[magic_number: 7]'`

You will see some output.  Press "q" then "enter" to quit the bots and see a summary 
of their actions.  You can view the full logs at `bot_run.log`.


#### Integration test runner

`mix bots.integration_test --v --workflow BotArmyStarter.Trees.SampleIntegration 
--custom '[magic_number: 7]'`

This will run all of the tests in parallel, logging output of each test and showing 
any errors.  It will complete with a standard exit status of 1 or 0, so you can use 
this in a build pipeline that depends on the exit status.


### Deploying

You can run the bots in a docker container.  A sample docker file is provided, but 
you will need to adjust it (particularly the `CMD` section).

You can also build a "release" which can be run as an executable.  _Be aware the 
release can only run on the same OS it was built on!_

Just run `mix release`, which will build it to 
`_build/prod/rel/bot_army_starter/bin/bot_army_starter`.

To run it `cd _build/prod/rel/bot_army_starter/` and then run `bin/bot_test eval 
'BotArmyStarter.Run.run(30)'` (See `lib/run.ex`).
