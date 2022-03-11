defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [top, body] = String.split(request, "\r\n\r\n")
    [request_line | headers] = String.split(top, "\r\n")
    [method, path, _] = String.split(request_line, " ")

    headers_map =
      headers
      |> Enum.map(&String.split(&1, ": "))
      |> Enum.into(%{}, fn [a, b] -> {a, b} end)

    param_list =
      body
      |> String.trim()
      |> URI.decode_query()

    %Conv{
      method: method,
      path: path,
      params: param_list,
      headers: headers_map
    }
  end
end
