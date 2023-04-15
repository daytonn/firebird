defmodule Utility.Result do
  def unwrap_ok({:ok, result}), do: result
  def unwrap_ok(_), do: nil
  def unwrap_ok!({:ok, result}), do: result

  def to_boolean(v), do: !!v

  def ok(v), do: {:ok, v}
  def error(v), do: {:error, v}
end
