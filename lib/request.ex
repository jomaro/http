defmodule HTTP.Request do
  @type method :: :head, :get, :delete, :trace, :options, :post, :put, :patch

  defstruct [
    :method,
    :url,
    :req_headers,
    req_body: "",
    query: [],
    url_params: [],
    secure?: true,
  ]
end
