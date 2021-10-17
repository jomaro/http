defmodule HTTP.Response do
  alias HTTP.Request

  defstruct [
    :request,
    :status_code,
    :headers,
    :body,
  ]
end
