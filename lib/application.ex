defmodule Http do
  use Application

  def start(_call, _expr) do
    Supervisor.start_link(children(), [
      strategy: :one_for_one,
      name: HTTP.Supervisor,
    ])
  end

  defp children() do
    [
      HTTP.Adapters.TeslaAdapter.child_spec(),
    ]
    |> List.flatten()
  end
end
