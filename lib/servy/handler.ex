defmodule Servy.Handler do
  import Servy.Plugins
  alias Servy.Conv
  import Servy.Parser
  @pages_path Path.expand("pages", File.cwd!())
  def handle(request) do
    request
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{} = conv) do
    case conv do
      %{method: "GET", path: "/wildthings"} ->
        %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}

      %{method: "POST", path: "/bears"} ->
        case conv.headers do
          %{"Content-Type" => "application/x-www-form-urlencoded"} ->
            Servy.Bearcontroller.creat(conv)

          _ ->
            %{
              conv
              | status: 201,
                resp_body:
                  "the bear named Unkown has been created successfuly and the type of this bear is Unkown"
            }
        end

      %{method: "GET", path: "/bears"} ->
        Servy.Bearcontroller.index(conv)

      %{method: "GET", path: "/api/bears"} ->
        Servy.Api.Bearcontroller.index(conv)

      %{method: "GET", path: "/about"} ->
        file =
          @pages_path
          |> Path.join("about.html")
          |> File.read()

        case file do
          {:ok, content} -> %{conv | status: 200, resp_body: content}
          {:error, :enoent} -> %{conv | status: 404, resp_body: "file not found"}
          {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
        end

      %{method: "GET", path: "/bears/" <> id} ->
        Servy.Bearcontroller.show(conv, id)

      %{method: "DELETE"} ->
        %{conv | status: 401, resp_body: "You are not allowed to Delete the path #{conv.path}"}

      _ ->
        %{conv | status: 404, resp_body: "No #{conv.path} here!"}
    end
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: #{conv.resp_content_type}
    Content-Length: #{String.length(conv.resp_body)}
    
    #{conv.resp_body}
    """
  end
end
