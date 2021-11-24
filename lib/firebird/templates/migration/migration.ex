defmodule Firebird.Templates.Migration do
  require EEx

  alias Firebird.Env

  EEx.function_from_file(
    :def,
    :generate,
    Path.expand("migration.eex", "lib/firebird/templates/migration"),
    [
      :app_name,
      :repo_name,
      :options,
      :table_name,
      :fields
    ]
  )

  def create_migration([schema_name | [table_name | attributes]]) do
    [binary_id: binary_id] = Env.get(:generators, binary_id: false)
    app_name = Inflex.camelize(Env.get(:app_name, "MyApp"))
    repo_name = Inflex.pluralize(schema_name)
    options = options(binary_id: binary_id)
    filename = "#{table_name}.exs"
    table_name = ":#{table_name}"

    content =
      generate(
        app_name,
        repo_name,
        options,
        table_name,
        fields(attributes, binary_id)
      )

    filename = Calendar.strftime(DateTime.utc_now(), "%Y%m%d%H%M%S") <> "_create_#{filename}"

    path = Path.expand("priv/repo/migrations")
    filepath = "#{path}/#{filename}"

    File.mkdir_p!(path)
    File.write!(filepath, content)

    {:ok, filepath}
  end

  def options(binary_id: false), do: nil
  def options(binary_id: true), do: ", primary_key: false"

  def fields(nil, false), do: fields([], false)
  def fields(nil, true), do: fields([], true)
  def fields([], true), do: [create_field(["id", "binary_id"])]
  def fields([], false), do: []

  def fields(attributes, true) do
    ["id:binary_id" | attributes]
    |> Enum.map(&create_field(&1))
  end

  def fields(attributes, false), do: Enum.map(attributes, &create_field(&1))

  defp create_field(attr) when is_binary(attr) do
    create_field(String.split(attr, ":"))
  end

  defp create_field([field, "references", _] = list) when is_list(list) do
    "add :#{field}, #{reference_type(Env.get(:generators, []))}, null: false"
  end

  defp create_field([field, type, "null"] = list) when is_list(list) do
    "add :#{field}, :#{translate_type(type)}"
  end

  defp create_field([field, type] = list) when is_list(list) do
    "add :#{field}, :#{translate_type(type)}, null: false"
  end

  defp reference_type(binary_id: true), do: ":binary_id"
  defp reference_type(_), do: ":integer"

  defp translate_type("int"), do: "integer"
  defp translate_type("string"), do: "text"
  defp translate_type("bool"), do: "boolean"
  defp translate_type("json"), do: "map"
  defp translate_type(type), do: type
end
