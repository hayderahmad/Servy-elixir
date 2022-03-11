defmodule Servy.Bearcontroller do
  alias Servy.Wildthings
  @templates_path Path.expand("templates", File.cwd!())
  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&(&1.name <= &2.name))

    render(conv, "index.eex", bears: bears)
  end

  def show(conv, id) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
  end

  def creat(conv) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"
    }
  end
end
