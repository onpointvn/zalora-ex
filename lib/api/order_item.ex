defmodule Zalora.OrderItem do
  alias Zalora.Client
  alias Zalora.MapHelper

  @doc """
  Get order items by given order items ids or order ids

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Orders/GET_v2-order-items-get
  """
  @get_order_items_schema %{
    order_item_ids: [type: {:array, :integer}, length: [min: 1]],
    order_ids: [type: {:array, :integer}, length: [min: 1]]
  }
  def get_order_items(params, opts \\ []) do
    with {:ok, query} <- Contrak.validate(params, @get_order_items_schema),
         {:ok, client} <- Client.new(opts) do
      query =
        query
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

      client
      |> Client.get("/v2/order-items", query: query)
      |> case do
        {:ok, items} = result when is_list(items) ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end
end
