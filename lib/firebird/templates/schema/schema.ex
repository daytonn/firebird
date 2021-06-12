defmodule Firebird.Templates.Schema do
  require EEx

  alias Firebird.Env

  EEx.function_from_file(
    :def,
    :generate,
    Path.expand("schema.eex", "lib/firebird/templates/schema"),
    [
      :app_name,
      :schema_name,
      :binary_id,
      :table_name,
      :instance_name,
      :fields,
      :attributes
    ]
  )

  def fields(nil), do: []
  def fields([]), do: []
  def fields(attributes), do: Enum.map(attributes, &create_field(&1))

  def validated_attributes(nil), do: []
  def validated_attributes([]), do: []

  def validated_attributes(attributes) do
    attributes
    |> Enum.map(&create_attribute(&1))
    |> Enum.reject(&is_nil(&1))
    |> Enum.join(", ")
  end

  defp create_field(attr) when is_binary(attr) do
    create_field(String.split(attr, ":"))
  end

  defp create_field([field, "references", _] = list) when is_list(list) do
    "field :#{field}, #{reference_type(Env.get(:generators, []))}, null: false"
  end

  defp create_field([field, type, "null"] = list) when is_list(list) do
    "field :#{field}, :#{type}"
  end

  defp create_field([field, type] = list) when is_list(list) do
    "field :#{field}, :#{type}, null: false"
  end

  defp reference_type(binary_id: true), do: ":binary_id"
  defp reference_type(_), do: ":integer"

  defp create_attribute(attribute) when is_binary(attribute) do
    create_attribute(String.split(attribute, ":"))
  end

  defp create_attribute([_, "references", _] = list) when is_list(list), do: nil
  defp create_attribute([_, _, "null"] = list) when is_list(list), do: nil
  defp create_attribute([attribute, _] = list) when is_list(list), do: ":#{attribute}"
end
