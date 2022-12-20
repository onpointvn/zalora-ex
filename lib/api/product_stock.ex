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

  @doc """
  Update stock for a product

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/ProductStock/put_v2_stock_product
  """
  def update_product_stock(list_params, opts \\ []) do
    opts = Keyword.put(opts, :use_json, true)

    with {:ok, payload} when is_list(payload) <- {:ok, list_params},
         {:ok, client} <- Client.new(opts) do

      client
      |> Client.put("/v2/stock/product", payload)
      |> case do
        {:ok, _} = result ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end
end
