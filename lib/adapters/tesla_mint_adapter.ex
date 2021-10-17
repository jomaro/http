defmodule HTTP.Adapters.TeslaMintAdapter do
  @moduledoc """
  A low footprint adapter

  use cases:
    - you want to make requests inside a Mix Task and don't want
      to create processes that will slowdown the VM start time
    - you want to make requests to a provider where it's worth
      to open and close the connection (with TLS handshake) at
      every request
  """

  alias HTTP.Request
  alias HTTP.Response
  alias HTTP.Security

  @mint_options [
    ciphers: Security.safe_ciphers(),
    secure_renegotiate: false,
    versions: [:"tlsv1.2", :"tlsv1.3"],
  ]

  def child_spec(), do: []

  @spec execute(Request.t(), keyword()) :: {:error, any} | {:ok, Response.t()}
  def execute(request = %Request{}, _options) do
    tesla_options = [
      method: request.method,
      url: request.url,
      query: request.query,
      headers: request.req_headers,
      body: request.req_body,
    ]

    response_tuple =
      request
      |> client()
      |> Tesla.request(tesla_options)

    case response_tuple do
      {:ok, env} ->
        {
          :ok,
          %Response{
            status_code: env.status,
            body: env.body,
            request: request,
          }
        }
      other -> other
    end
  end

  def execute!(request = %Request{}, options) do
    {:ok, response} = execute(request, options)

    response
  end

  defp client(_request = %Request{}) do
    middleware = []

    Tesla.client(middleware, {Tesla.Adapter.Mint, @mint_options})
  end
end
