defmodule Zalora.PaymentMethod do
  alias Zalora.Client

  @doc """
  Get all payment methods

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Payment%20Method/get_v2_payment_methods
  """
  @spec get_payment_methods(opts :: Keyword.t()) ::
          {:ok, list(map())} | {:error, any()}
  def get_payment_methods(opts \\ []) do
    with {:ok, client} <- Client.new(opts) do
      client
      |> Client.get("/v2/payment-methods")
      |> case do
        {:ok, _} = result ->
          result

        error ->
          error
      end
    end
  end
end
