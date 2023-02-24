defmodule Zalora.Product.Status do
  def active, do: "active"

  def inactive, do: "inactive"

  def deleted, do: "deleted"

  def enum do
    [
      active(),
      inactive(),
      deleted()
    ]
  end
end

defmodule Zalora.Product do
  alias Zalora.Client
  alias Zalora.MapHelper

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

  @doc """
  Update a product in a product set

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Product/put_v2_product_set__productSetId__products__productId_
  """
  @update_product_set_product_schema %{
    seller_sku: :string,
    status: [type: :string, in: Zalora.Product.Status.enum()],
    variation: :string,
    product_identifier: :string
  }

  @spec update_product_set_product(
          product_set_id :: integer(),
          product_id :: integer(),
          params :: map(),
          opts :: Keyword.t()
        ) :: {:ok, map()} | {:error, any()}
  def update_product_set_product(product_set_id, product_id, params, opts \\ []) do
    with {:ok, payload} <- Contrak.validate(params, @update_product_set_product_schema),
         {:ok, client} <- Client.new(opts) do
      payload =
        payload
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

      client
      |> Client.put("/v2/product-set/#{product_set_id}/products/#{product_id}", payload)
      |> case do
        {:ok, data} ->
          {:ok, data}

        error ->
          error
      end
    end
  end
end
