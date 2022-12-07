defmodule Mix.Tasks.Fbx.Gen.Migration do
  @shortdoc "Generate a firebird template"

  @moduledoc """
  Generates a firebird template

    mix fbx.gen
  """
  @requirements ["app.config"]

  use Mix.Task

  alias Firebird.Templates.Migration

  @impl Mix.Task
  def run(args) do
    args
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
