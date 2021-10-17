defmodule HTTP.Response do

  defstruct [
    :request,
    :status_code,
    :headers,
    :body,
  ]
end
