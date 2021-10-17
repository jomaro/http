defmodule HTTP.Adapter do
  alias HTTP.Request

  @callback execute(request :: Request.t(), options :: keyword()) :: %{}
end
