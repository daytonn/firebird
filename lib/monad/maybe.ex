defmodule Monad.Maybe do
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
  def create(nil), do: %Nothing{value: nil}
  def create(true), do: %Something{value: true}
  def create(false), do: %Nothing{value: false}
  def create(%Nothing{} = nothing), do: nothing
  def create({:error, error}), do: %Nothing{value: error}
  def create({:ok, value}), do: %Something{value: value}
  def create(%Something{} = something), do: something
  def create(value), do: %Something{value: value}

  @doc """
  Unwraps the value with the given function if given Something.

  ## Examples
      iex> unwrap(%Nothing{}, &identity/1)
      nil

      iex> unwrap(%Something{value: "value"}, &identity/1)
      "value"

  """
  def unwrap(%Nothing{}, _fun), do: nil
  def unwrap(%Something{value: value}, fun), do: apply(fun, [value])

  def unwrap(%Something{value: value}, fun, args) when is_list(args),
    do: apply(fun, [value] ++ args)

  def unwrap(%Something{} = something, fun, arg), do: unwrap(something, fun, [arg])

  def unwrap(%Something{} = something, fun, arg1, arg2),
    do: unwrap(something, fun, [arg1, arg2])

  def unwrap(%Something{} = something, fun, arg1, arg2, arg3),
    do: unwrap(something, fun, [arg1, arg2, arg3])

  def unwrap(%Something{} = something, fun, arg1, arg2, arg3, arg4),
    do: unwrap(something, fun, [arg1, arg2, arg3, arg4])

  @doc """
  Creates a maybe and unwraps it with the given function

  ## Examples
      iex> maybe(nil, fn _v -> "not nothing" end)
      nil

      iex> maybe("value", &identity/1)
      "value"

      iex> maybe(false, &identity/1)
      false
  """
  def maybe(value, fun) do
    value
    |> create()
    |> unwrap(fun)
  end

  def maybe(value, fun, args) when is_list(args) do
    value
    |> create()
    |> unwrap(fun, args)
  end

  def maybe(value, fun, arg), do: maybe(value, fun, [arg])
  def maybe(value, fun, arg1, arg2), do: maybe(value, fun, [arg1, arg2])
  def maybe(value, fun, arg1, arg2, arg3), do: maybe(value, fun, [arg1, arg2, arg3])
  def maybe(value, fun, arg1, arg2, arg3, arg4), do: maybe(value, fun, [arg1, arg2, arg3, arg4])
end
