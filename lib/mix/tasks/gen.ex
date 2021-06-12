defmodule Mix.Tasks.Gen do
  @moduledoc "Generate a firebird template"
  @shortdoc "Generate a firebird template"
  @requirements ["app.config"]

  use Mix.Task

  alias Firebird.Env
  alias Firebird.Templates.Schema

  @impl Mix.Task
  def run(["schema" | args]) do
    [schema_name | [table_name | attributes]] = args
    [binary_id: binary_id] = Env.get(:generators, binary_id: false)
    instance_name = Inflex.singularize(table_name)
    app_name = Inflex.camelize(Env.get(:app_name, "MyApp"))
    app_directory = Inflex.underscore(app_name)
    path = Path.expand("lib/#{app_directory}/schemas")
    filepath = "#{path}/#{instance_name}.ex"

    content =
      Schema.generate(
        app_name,
        schema_name,
        binary_id,
        table_name,
        instance_name,
        Schema.fields(attributes),
        Schema.validated_attributes(attributes)
      )

    Mix.shell().info("* creating #{path}")
    File.mkdir_p!(path)
    File.write!(filepath, content)
  end

  def run(["context" | args]), do: Mix.shell().info(Enum.join(args, " "))
  def run(["migration" | args]), do: Mix.shell().info(Enum.join(args, " "))
  def run(args), do: Mix.shell().info(Enum.join(args, " "))
end
