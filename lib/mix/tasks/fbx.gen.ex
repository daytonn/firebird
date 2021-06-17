defmodule Mix.Tasks.Fbx.Gen do
  @moduledoc "Generate a firebird template"
  @requirements ["app.config"]

  use Mix.Task

  alias Firebird.Env
  alias Firebird.Templates.Context
  alias Firebird.Templates.Migration
  alias Firebird.Templates.Schema

  @impl Mix.Task
  @shortdoc "Generate a firebird template"
  def run(["schema" | args]) do
    args
    |> Schema.create_schema()
    |> print_filepath()

    args
    |> Migration.create_migration()
    |> print_filepath()
  end

  def run(["context" | args]) do
    args
    |> Context.create_context()
    |> print_filepath()

    [_ | rest] = args

    rest
    |> Schema.create_schema()
    |> print_filepath()

    rest
    |> Migration.create_migration()
    |> print_filepath()
  end

  def run(["migration" | args]) do
    args
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
