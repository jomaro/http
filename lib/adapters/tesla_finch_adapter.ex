defmodule HTTP.Adapters.TeslaFinchAdapter do
  @moduledoc """
  An adapter based on Finch which adds a connection poll over Mint

  If you need to make several requests to the same host, in a single
  execution of the application, you probably want to use this adapter
  """

  alias HTTP.Request
  alias HTTP.Response
  alias HTTP.Security

  @mint_options [
    transport_opts: [
      ciphers: Security.safe_ciphers(),
      secure_renegotiate: false,
      versions: [:"tlsv1.2", :"tlsv1.3"],
    ]
  ]

  @finch_adapter {Tesla.Adapter.Finch, name: FinchStatefulHTTP}

  def child_spec() do
    [
      {
        Finch,
        [
          name: FinchStatefulHTTP,
          pools: %{
            default: [size: 10, conn_opts: @mint_options],
          },
        ]
      }
    ]
  end

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

    Tesla.client(middleware, @finch_adapter)
  end
end
