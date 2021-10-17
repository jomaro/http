defmodule BaseHTTP do

  defmacro __using__(opts) do
    adapter = Keyword.get(opts, :adapter, HTTP.Adapters.TeslaFinchAdapter)

    quote do
      alias HTTP.Request

      @type method :: :delete | :get | :head | :options | :patch | :post | :put
      @type body :: binary()
      @type headers :: [{binary(), binary()}]
      @type options :: [option()]
      @type option :: {:timeout, integer()} | {:secure?, boolean()}

      @type response_tuple :: {:error, any} | {:ok, Response.t()}

      @default_options [
        timeout: 30_000,
        secure?: true,
      ]

      def child_spec() do
        adapter().child_spec()
      end

      @spec delete(binary(), headers(), options()) :: response_tuple
      def delete(url, headers \\ [], options \\ []) do
        %Request{
          method: :delete,
          url: url,
          req_headers: headers,
        }
        |> execute(options)
      end

      def delete!(url, headers \\ [], options \\ []) do
        {:ok, response} = delete(url, headers, options)

        response
      end

      @spec get(binary(), headers(), options()) :: response_tuple
      def get(url, headers \\ [], options \\ []) do
        %Request{
          method: :get,
          url: url,
          req_headers: headers,
        }
        |> execute(options)
      end

      def get!(url, headers \\ [], options \\ []) do
        {:ok, response} = get(url, headers, options)

        response
      end

      @spec head(binary(), headers(), options()) :: response_tuple
      def head(url, headers \\ [], options \\ []) do
        %Request{
          method: :head,
          url: url,
          req_headers: headers,
        }
        |> execute(options)
      end

      def head!(url, headers \\ [], options \\ [])  do
        {:ok, response} = head(url, headers, options)

        response
      end

      @spec options(binary(), headers(), options()) :: response_tuple
      def options(url, headers \\ [], options \\ []) do
        %Request{
          method: :options,
          url: url,
          req_headers: headers,
        }
        |> execute(options)
      end

      def options!(url, headers \\ [], options \\ []) do
        {:ok, response} = options(url, headers, options)

        response
      end

      @spec patch(binary(), body(), headers(), options()) :: response_tuple
      def patch(url, body, headers \\ [], options \\ []) do
        %Request{
          method: :patch,
          url: url,
          req_headers: headers,
          req_body: body,
        }
        |> execute(options)
      end

      def patch!(url, body, headers \\ [], options \\ []) do
        {:ok, response} = patch(url, body, headers, options)

        response
      end

      @spec post(binary(), body(), headers(), options()) :: response_tuple
      def post(url, body, headers \\ [], options \\ []) do
        %Request{
          method: :post,
          url: url,
          req_body: body,
          req_headers: headers,
        }
        |> execute(options)
      end

      def post!(url, body, headers \\ [], options \\ []) do
        {:ok, response} = post(url, body, headers, options)

        response
      end

      @spec put(binary(), body(), headers(), options()) :: response_tuple
      def put(url, body \\ "", headers \\ [], options \\ []) do
        %Request{
          method: :get,
          url: url,
          req_headers: headers,
          req_body: body,
        }
        |> execute(options)
      end

      def put!(url, body \\ "", headers \\ [], options \\ []) do
        {:ok, response} = put(url, body, headers, options)

        response
      end

      @spec request(method(), binary(), body(), headers(), options()) :: response_tuple
      def request(method, url, body \\ "", headers \\ [], options \\ []) do
        %Request{
          method: method,
          url: url,
          req_headers: headers,
          req_body: body,
        }
        |> execute(options)
      end

      def request!(method, url, body \\ "", headers \\ [], options \\ []) do
        {:ok, response} = request(method, url, body, headers, options)

        response
      end

      @spec execute(Request.t(), keyword()) :: response_tuple
      def execute(request = %Request{}, options \\ []) do
        options = Keyword.merge(@default_options, options)

        if Keyword.fetch!(options, :secure?) and Mix.env() != :dev and URI.parse(request.url)[:scheme] != "https" do
          raise "Only HTTPS is allowed when not in dev mode"
        end

        {request, options} = Enum.reduce(options, {request, []}, &HTTP.Internal.OptionHandler.handle_option/2)

        adapter().execute(request, options)
      end

      defp adapter() do
        unquote(adapter)
      end
    end
  end

end
