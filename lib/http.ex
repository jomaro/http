defmodule HTTP do
  use BaseHTTP, adapter: HTTP.Adapters.TeslaFinchAdapter
end
