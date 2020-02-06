defmodule BotArmyStarter.Actions.Sample do
  @moduledoc """
  Contrived examples of actions for guessing a number.

  """

  require Logger

  @doc """
  Sets `context.guess_count` to 0 and clears any `context.guess`.
  """
  def init_guesses_count(_context) do
    {:succeed, guess_count: 0, guess: nil}
  end

  @doc """
  Makes sure the provided number is between 0 and 10 (inclusive)
  """
  def validate_number(_context, n) do
    if n >= 0 and n <= 10 do
      Logger.info("Target number is #{n}")
      :succeed
    else
      Logger.error("Target number must be between 0 and 10, received #{n}")
      :fail
    end
  end

  @doc """
  Chooses a random number between 1 and 10 and saves it to `context.guess`.  Also
  increments `context.guess_count`.

  (Note this will error and the bot will die if `guess_count` has not been set.)
  """
  def make_guess(%{guess_count: guess_count}) when is_integer(guess_count) do
    guess = Enum.random(0..10)
    Logger.info("Is it... #{guess}?")
    {:succeed, guess: guess, guess_count: guess_count + 1}
  end

  @doc """
  Succeeds if the guess matches the target, fails otherwise.
  """
  def check_guess(%{guess: guess}, target) when guess == target, do: :succeed
  def check_guess(_, _), do: :fail

  @doc """
  Fails or succeeds based on if `context.guess_count` is less than `max_guesses`.
  """
  def more_guesses_left?(%{guess_count: guess_count}, max_guesses) do
    if guess_count < max_guesses do
      :succeed
    else
      {:error, :out_of_guesses}
    end
  end

  @doc """
  Validates the guess count (used in integration tests).
  """
  def validate_guess_count(%{guess_count: guess_count}, expected)
      when guess_count == expected,
      do: :succeed

  def validate_guess_count(_, _), do: :fail
end
