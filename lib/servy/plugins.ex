defmodule Servy.Plugins do
  alias Servy.Conv

  def track(%Conv{} = conv) do
    if Mix.env() != :test do
      cond do
        conv.status == 404 ->
          IO.puts("Warning: #{conv.path} is in the loose!")
          conv

        true ->
          conv
      end
    end

    conv
  end

  def rewrite_path(%Conv{} = conv) do
    case conv do
      %{path: "/wildlife"} -> %Conv{conv | path: "/wildthings"}
      _ -> conv
    end
  end

  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      IO.inspect(conv)
    end

    conv
  end
end
