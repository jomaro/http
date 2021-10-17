defmodule HTTP.Internal.OptionHandler do
  @moduledoc false

  def handle_option(option = {:timeout, _timeout}, {request, options}) do
    {request, [option | options]}
  end
  def handle_option({:body, body}, {request, options}) do
    {
      %{request | body: body},
      options
    }
  end
  def handle_option({:query, data}, {request, options}) do
    {
      %{request | url: request.url <> "?" <> URI.encode_query(data)},
      options
    }
  end
  def handle_option({:headers, headers}, {request, options}) do
    {
      %{request | headers: request.headers ++ headers},
      options
    }
  end
  def handle_option({:json, data}, {request, options}) do
    {
      request
      |> prepend_header("content-type", "application/json")
      |> put_body(Jason.encode!(data)),
      options
    }
  end
  def handle_option({:secure?, _}, {request, options}) do
    {request, options}
  end

  defp prepend_header(request, name, value) do
    %{request | headers: [{name, value} | request.headers]}
  end

  defp put_body(request, body) do
    %{request | req_body: body}
  end
end
