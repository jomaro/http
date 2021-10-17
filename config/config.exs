use Mix.Config

config :tesla, :adapter, {Tesla.Adapter.Finch, name: FinchStatefulHTTP}
