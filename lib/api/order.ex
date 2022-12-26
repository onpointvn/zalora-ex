defmodule Zalora.Order.Status do
  def status_shipped, do: "status_shipped"
  def status_delivered, do: "status_delivered"
  def status_failed, do: "status_failed"
  def status_returned, do: "status_returned"
  def status_canceled, do: "status_canceled"
  def status_pending, do: "status_pending"
  def status_ready_to_ship, do: "status_ready_to_ship"
  def group_economy, do: "group_economy"
  def group_express, do: "group_express"
  def group_standard, do: "group_standard"
  def group_digital, do: "group_digital"
  def group_sameday, do: "group_sameday"
  def group_air, do: "group_air"
  def group_surface, do: "group_surface"
  def group_missing_external_invoice_access_key, do: "group_missing_external_invoice_access_key"
  def group_ready_to_ship_manifested, do: "group_ready_to_ship_manifested"
  def group_ready_to_ship_nonmanifested, do: "group_ready_to_ship_nonmanifested"

  def enum do
    [
      status_shipped(),
      status_delivered(),
      status_failed(),
      status_returned(),
      status_canceled(),
      status_pending(),
      status_ready_to_ship(),
      group_economy(),
      group_express(),
      group_digital(),
      group_sameday(),
      group_air(),
      group_surface(),
      group_missing_external_invoice_access_key(),
      group_ready_to_ship_manifested(),
      group_ready_to_ship_nonmanifested()
    ]
  end
end

defmodule Zalora.Order.Packed do
  def fully_packed, do: "fully_packed"
  def partially_packed, do: "partially_packed"
  def not_packed, do: "not_packed"

  def enum, do: [fully_packed(), partially_packed(), not_packed()]
end

defmodule Zalora.Order.Delivery do
  def shipped_under_24h, do: "shippedUnder24h"
  def not_shipped_under_24h, do: "notShippedUnder24h"
  def not_shipped_under_24_business_hours, do: "notShippedUnder24BusinessHours"

  def enum,
    do: [shipped_under_24h(), not_shipped_under_24h(), not_shipped_under_24_business_hours()]
end

defmodule Zalora.Order.OrderBy do
  def created_at, do: "created_at"
  def updated_at, do: "updated_at"

  def enum, do: [created_at(), updated_at()]
end

defmodule Zalora.Order.OrderDir do
  def asc, do: "asc"
  def desc, do: "desc"

  def enum, do: [asc(), desc()]
end

defmodule Zalora.Order.DocumentType do
  def invoice, do: "invoice"
  def export_invoice, do: "exportInvoice"
  def shipping_label, do: "shippingLabel"
  def shipping_parcel, do: "shippingParcel"
  def carrier_manifest, do: "carrierManifest"
  def serial_number, do: "serialNumber"

  def enum,
    do: [
      invoice(),
      export_invoice(),
      shipping_label(),
      shipping_parcel(),
      carrier_manifest(),
      serial_number()
    ]
end

defmodule Zalora.Order do
  alias Zalora.Client
  alias Zalora.MapHelper

  @doc """
  Get orders

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/get_v2_orders
  """
  @get_order_schema %{
    limit: [type: :integer, required: true],
    offset: [type: :integer, required: true],
    section: [type: :string, in: Zalora.Order.Status.enum()],
    date_start: Date,
    date_end: Date,
    order_numbers: {:array, :string},
    packed: [type: :string, in: Zalora.Order.Packed.enum()],
    customers: {:array, :string},
    printed_status: :boolean,
    tags: {:array, :string},
    product_sku: {:array, :string},
    delivery: [type: :string, in: Zalora.Order.Delivery.enum()],
    shipment_type: :string,
    shipment_providers: {:array, :string},
    payment_methods: {:array, :string},
    outlet: :boolean,
    invoice_required: :boolean,
    cancelation_reasons: {:array, :string},
    fulfilment_type: {:array, :string},
    order_sources: {:array, :string},
    seller_names: {:array, :string},
    update_date_start: Date,
    update_date_end: Date,
    warehouses: {:array, :string},
    order: [type: :string, in: Zalora.Order.OrderBy.enum()],
    order_dir: [type: :string, in: Zalora.Order.OrderDir.enum()],
    orderIds: {:array, :integer}
  }
  @spec get_orders(params :: map(), opts :: Keyword.t()) :: {:ok, map()} | {:error, any()}
  def get_orders(params, opts \\ []) do
    params = MapHelper.clean_nil(params)

    with {:ok, query} <- Contrak.validate(params, @get_order_schema),
         {:ok, client} <- Client.new(opts) do
      query =
        query
        |> MapHelper.clean_nil()
        |> MapHelper.to_query()

      client
      |> Client.get("v2/orders", query: query)
      |> case do
        {:ok, %{"items" => _, "pagination" => _}} = result ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end

  @doc """
  Pack order

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/post_v2_orders_statuses_set_to_packed_by_marketplace
  """
  @order_items_param %{
    order_item_id: [type: :integer, required: true],
    serialNumber: :string
  }
  @pack_order_schema %{
    order_items: [type: @order_items_param, required: true],
    delivery_type: [type: :string, required: true],
    shipping_provider: :string,
    tracking_number: :string
  }
  def pack_order(params, opts \\ []) do
    params = MapHelper.clean_nil(params)

    with {:ok, body} <- Contrak.validate(params, @pack_order_schema),
         {:ok, client} <- Client.new(opts) do
      body =
        body
        |> MapHelper.clean_nil()
        |> MapHelper.to_query()

      client
      |> Client.post("v2/orders/statuses/set-to-packed-by-marketplace", body)
      |> case do
        {:ok, %{"orderItemIds" => _}} = result ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end

  @doc """
  Export order document

  Reference
  https://sellercenter-api-staging.zalora.com.ph/docs/#/Orders/post_v2_orders_export_document
  """
  @export_document_schema %{
    order_ids: [type: {:array, :integer}, required: true],
    document_type: [type: :string, in: Zalora.Order.DocumentType.enum(), required: true]
  }
  def export_document(params, opts \\ []) do
    params = MapHelper.clean_nil(params)

    with {:ok, body} <- Contrak.validate(params, @export_document_schema),
         {:ok, client} <- Client.new(opts) do
      body =
        body
        |> MapHelper.clean_nil()
        |> MapHelper.to_query()

      client
      |> Client.post("v2/orders/export-document", body)
      |> case do
        {:ok, %{"id" => _, "sellerId" => _, "exportContent" => _}} = result ->
          result

        {:ok, data} ->
          {:error, data}

        error ->
          error
      end
    end
  end
end
