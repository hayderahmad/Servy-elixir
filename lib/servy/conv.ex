defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            resp_body: "",
            status: "",
            params: %{},
            headers: %{},
            resp_content_type: "text/html"

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end
end
