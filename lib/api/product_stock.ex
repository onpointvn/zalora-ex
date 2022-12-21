defmodule Zalora.ProductStock do
  alias Zalora.MapHelper
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
  @stock_change_schema %{
    product_id: [type: :integer, required: true],
    quantity: [type: :integer, required: true, number: [min: 0]]
  }
  @spec update_product_stock(stock_changes :: list(map()), opts :: Keyword.t()) ::
          {:ok, list(map())} | {:error, any()}
  def update_product_stock(stock_changes, opts \\ []) do
    opts = Keyword.put(opts, :use_json, true)

    validation_result =
      Enum.reduce_while(stock_changes, {:ok, []}, fn stock_change, {:ok, stock_changes_acc} ->
        Contrak.validate(stock_change, @stock_change_schema)
        |> case do
          {:ok, stock_change} ->
            {:cont, {:ok, [stock_change | stock_changes_acc]}}

          error ->
            {:halt, error}
        end
      end)

    with {:ok, stock_changes} <- validation_result,
         {:ok, client} <- Client.new(opts) do
      payload =
        stock_changes
        |> Enum.reverse()
        |> Enum.map(&MapHelper.to_query(&1))

      client
      |> Client.put("/v2/stock/product", payload)
      |> case do
        {:ok, product_stocks} = result when is_list(product_stocks) ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end
end
