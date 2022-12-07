defmodule Mix.Tasks.Fbx.Gen.Schema do
  @shortdoc "Generate a firebird template"

  @moduledoc """
  Generates an Ecto schema

    mix fbx.gen.schema
  """
  @requirements ["app.config"]

  use Mix.Task

  alias Firebird.Templates.Migration
  alias Firebird.Templates.Schema

  @impl Mix.Task
  def run(args) do
    args
    |> Schema.create_schema()
    |> print_filepath()

    args
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
