defmodule Firebird.Templates.Repo do
  require EEx

  alias Firebird.Env

  EEx.function_from_file(
    :def,
    :generate,
    Path.expand("repo.eex", "lib/firebird/templates/repo"),
    [
      :app_name,
      :repo_name,
      :schema_name
    ]
  )

  def create_context([repo_name | _]) do
    app_slug = Env.get(:app_name, "MyApp")
    app_name = Inflex.camelize(app_slug)
    context_name = "#{Inflex.underscore(repo_name)}.ex"
    schema_name = Inflex.singularize(repo_name)
    content = generate(app_name, repo_name, schema_name)
    path = Path.expand("lib/#{app_slug}/repos")
    filepath = "#{path}/#{context_name}"

    File.mkdir_p!(path)
    File.write!(filepath, content)

    {:ok, filepath}
  end
end
