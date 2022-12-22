defmodule Zalora.ProductPrice do
  alias Zalora.Client
  alias Zalora.MapHelper

  @doc """
  Get list of product price

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Product%20Price/get_v2_prices
  """
  @get_product_prices_schema %{
    product_set_ids: [type: {:array, :integer}, required: true]
  }
  @spec get_product_prices(params :: map(), opts :: Keyword.t()) ::
          {:ok, map()} | {:error, map()} | {:error, any()}
  def get_product_prices(params, opts \\ []) do
    params = MapHelper.clean_nil(params)

    with {:ok, query} <- Contrak.validate(params, @get_product_prices_schema),
         {:ok, client} <- Client.new(opts) do
      query =
        query
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

      client
      |> Client.get("/v2/prices", query: query)
      |> case do
        {:ok, prices} = result when is_list(prices) ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end
end
