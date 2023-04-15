defmodule Monad.Otherwise do
  alias Monad.Nothing
  alias Monad.Something

  @doc """
  Creates a maybe type, either nothing or something, depending on
  the given argument.

  ## Examples
      iex> create()
      %Nothing{}

      iex> create(nil)
      %Nothing{}

      iex> create({:error, "Error message"})
      %Nothing{}

      iex> create(false)
      %Something{value: false}

      iex> create("")
      %Something{value: ""}

      iex> create({:ok, "value"})
      %Something{value: "value"}
  """
  def create(), do: create(nil)
  def create(nil), do: %Nothing{}
  def create(%Nothing{} = nothing), do: nothing
  def create({:error, _}), do: %Nothing{}
  def create({:ok, value}), do: %Something{value: value}
  def create(%Something{} = something), do: something
  def create(value), do: %Something{value: value}

  @doc """
  Unwraps the value with the given function if given Something.

  ## Examples
      iex> unwrap(%Nothing{}, fun -> "alternative" end)
      "alternative"

      iex> unwrap(%Something{value: "value"}, &identity/1)
      nil
  """
  def unwrap(%Something{value: value}, _fun), do: value
  def unwrap(%Nothing{}, fun), do: fun.()

  @doc """
  Creates a maybe and unwraps it with the given function

  ## Examples
      iex> otherwise(nil, fn -> "something else" end)
      "something else"

      iex> otherwise(false, fn -> "something else" end)
      "something else"

      iex> otherwise("value", fn -> "something else" end)
      "value"
  """
  def otherwise(value, fun) do
    value
    |> create()
    |> unwrap(fun)
  end
end
