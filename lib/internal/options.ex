defmodule HTTP.Internal.OptionHandler do
  def handle_option({request, options}, option = {:timeout, _timeout}) do
    {request, [option | options]}
  end
  def handle_option({request, options}, {:body, body}) do
    {
      %{request | body: body},
      options
    }
  end
  def handle_option({request, options}, {:query, data}) do
    {
      %{request | url: request.url <> "?" <> URI.encode_query(data)},
      options
    }
  end
  def handle_option({request, options}, {:headers, headers}) do
    {
      %{request | headers: request.headers ++ headers},
      options
    }
  end
  def handle_option({request, options}, {:json, data}) do
    {
      request
      |> prepend_header("content-type", "application/json")
      |> put_body(Jason.encode!(data)),
      options
    }
  end

  defp prepend_header(request, name, value) do
    %{request | headers: [{name, value} | request.headers]}
  end

  defp put_body(request, body) do
    %{request | req_body: body}
  end
end
