defmodule Mix.Tasks.Fbx.Gen.Repo do
  @shortdoc "Generate a firebird template"

  @moduledoc """
  Generates a firebird template

    mix fbx.gen
  """
  @requirements ["app.config"]

  use Mix.Task

  alias Firebird.Templates.Repo
  alias Firebird.Templates.Migration
  alias Firebird.Templates.Schema

  @impl Mix.Task
  def run(args) do
    args
    |> Repo.create_context()
    |> print_filepath()

    [_ | rest] = args

    rest
    |> Schema.create_schema()
    |> print_filepath()

    rest
    |> Migration.create_migration()
    |> print_filepath()
  end

  defp print_filepath({:ok, filepath}), do: Mix.shell().info("* creating #{filepath}")
end
