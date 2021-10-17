defmodule HTTP.Adapters.TeslaAdapter do
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

  @spec execute(Request.t()) :: {:error, any} | {:ok, Response.t()}
  def execute(request = %Request{}) do
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

  def execute!(request = %Request{}) do
    {:ok, response} = execute(request)

    response
  end

  defp client(_request = %Request{}) do
    middleware = []

    Tesla.client(middleware)
  end
end
