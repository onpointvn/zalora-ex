defmodule Zalora.ProductStock do
  alias Zalora.Client

  @doc """
  Get stock for a product

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/ProductStock/get_v2_stock_product__productId_
  """
  @spec get_product_stock(product_id :: integer(), opts :: Keyword.t()) ::
          {:ok, list(map())} | {:error, any()}
  def get_product_stock(product_id, opts \\ []) do
    with {:ok, client} <- Client.new(opts),
         {:ok, %{"sellerSku" => _} = produck_stock} <-
           Client.get(client, "/v2/stock/product/#{product_id}") do
      {:ok, produck_stock}
    else
      {:ok, data} ->
        {:error, data}

      error ->
        error
    end
  end
end
