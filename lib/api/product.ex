defmodule Zalora.Product do
  alias Zalora.Client

  @doc """
  Get list of product for a product set

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Product/get_v2_product_set__productSetId__products
  """
  @spec get_product_set_products(product_set_id :: integer(), opts :: Keyword.t()) ::
          {:ok, list(map())} | {:error, any()}
  def get_product_set_products(product_set_id, opts \\ []) do
    with {:ok, client} <- Client.new(opts),
         {:ok, items} when is_list(items) <-
           Client.get(client, "/v2/product-set/#{product_set_id}/products") do
      {:ok, items}
    else
      {:ok, data} ->
        {:error, data}

      error ->
        error
    end
  end
end
