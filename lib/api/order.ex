defmodule Zalora.Order.OrderSection do
  @moduledoc """
  Enumeration for querying order by section

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/get_v2_orders
  """

  @doc """
  returns orders with order items status shipped
  """
  def status_shipped, do: "status_shipped"

  @doc """
  returns orders with order items status delivered
  """
  def status_delivered, do: "status_delivered"

  @doc """
  returns orders with order items status failed
  """
  def status_failed, do: "status_failed"

  @doc """
  returns orders with order items status returned
  """
  def status_returned, do: "status_returned"

  @doc """
  returns orders with order items status canceled
  """
  def status_canceled, do: "status_canceled"

  @doc """
  returns orders with order items status pending
  """
  def status_pending, do: "status_pending"

  @doc """
  returns orders with order items status ready_to_ship
  """
  def status_ready_to_ship, do: "status_ready_to_ship"

  @doc """
   returns orders with pending status and economy shipment provider type
  """
  def group_economy, do: "group_economy"

  @doc """
  returns orders with pending status and express shipment provider type
  """
  def group_express, do: "group_express"

  @doc """
  returns orders with pending status and standard shipment provider type
  """
  def group_standard, do: "group_standard"

  @doc """
  returns orders with pending status and digital shipment provider type
  """
  def group_digital, do: "group_digital"

  @doc """
  returns orders with pending status and sameday shipment provider type
  """
  def group_sameday, do: "group_sameday"

  @doc """
  returns orders with pending status and air shipment provider type
  """
  def group_air, do: "group_air"

  @doc """
  returns orders with pending status and surface shipment provider type
  """
  def group_surface, do: "group_surface"

  @doc """
  returns orders with pending or canceled status and invoice key is empty
  """
  def group_missing_external_invoice_access_key, do: "group_missing_external_invoice_access_key"

  def group_kpi_rejection_rate, do: "group_kpi_rejection_rate"

  def group_kpi_return_rate, do: "group_kpi_return_rate"

  @doc """
  returns orders with ready to ship status and manifest is exists
  """
  def group_ready_to_ship_manifested, do: "group_ready_to_ship_manifested"

  @doc """
  returns orders with ready to ship status and manifest is not exists
  """
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
      group_standard(),
      group_digital(),
      group_sameday(),
      group_air(),
      group_surface(),
      group_missing_external_invoice_access_key(),
      group_kpi_rejection_rate(),
      group_kpi_return_rate(),
      group_ready_to_ship_manifested(),
      group_ready_to_ship_nonmanifested()
    ]
  end
end

defmodule Zalora.Order.OrderPacked do
  @moduledoc """
  Enumeration for querying order by packed status

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/get_v2_orders
  """

  @doc """
  all of order items packed
  """
  def fully_packed, do: "fully_packed"

  @doc """
  part of order items packed
  """
  def partially_packed, do: "partially_packed"

  @doc """
  no order items packed
  """
  def not_packed, do: "not_packed"

  def enum do
    [fully_packed(), partially_packed(), not_packed()]
  end
end

defmodule Zalora.Order.OrderDelivery do
  @moduledoc """
  Enumeration for querying order by delivery

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/get_v2_orders
  """

  @doc """
  Orders with the status of the Order Item was set to shipped less or equal than 24 hours ago
  """
  def shipped_under_24h, do: "shippedUnder24h"

  @doc """
  Orders with the status of the Order Item was set to shipped more than 24 hours ago
  """
  def not_shipped_under_24h, do: "notShippedUnder24h"

  @doc """
  Orders with the status of the Order Item was set to shipped more than 24 business hours ago
  """
  def not_shipped_under_24_business_hours, do: "notShippedUnder24BusinessHours"

  def enum do
    [shipped_under_24h(), not_shipped_under_24h(), not_shipped_under_24_business_hours()]
  end
end

defmodule Zalora.Order.ShipmentType do
  def warehouse, do: "warehouse"

  def dropshipping, do: "dropshipping"

  def crossdocking, do: "crossdocking"

  def dropshipping_crossdocking, do: "dropshipping_crossdocking"

  def crossdocking_dropshipping, do: "crossdocking_dropshipping"

  def enum do
    [
      warehouse(),
      dropshipping(),
      crossdocking(),
      dropshipping_crossdocking(),
      crossdocking_dropshipping()
    ]
  end
end

defmodule Zalora.Order.FulfillmentType do
  @moduledoc """
  Enumeration for querying order by fulfillment type

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/get_v2_orders
  """

  @doc """
  means the type of shipment not from your own warehouse
  """
  def merchant, do: "merchant"

  @doc """
  means the type of shipment from your own warehouse
  """
  def venture, do: "venture"

  def enum do
    [merchant(), venture()]
  end
end

defmodule Zalora.Order.OrderDocumentType do
  @moduledoc """
  Enumeration for export an order document in PDF format

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Orders/post_v2_orders_export_document
  """

  def invoice, do: "invoice"

  def export_invoice, do: "exportInvoice"

  def shipping_label, do: "shippingLabel"

  def shipping_parcel, do: "shippingParcel"

  def carrier_manifest, do: "carrierManifest"

  def serial_number, do: "serialNumber"

  def enum do
    [
      invoice(),
      export_invoice(),
      shipping_label(),
      shipping_parcel(),
      carrier_manifest(),
      serial_number()
    ]
  end
end

defmodule Zalora.Order.OrderDeliveryType do
  def dropship, do: "dropship"

  def pickup, do: "pickup"

  def send_to_warehouse, do: "send_to_warehouse"

  def enum do
    [
      dropship(),
      pickup(),
      send_to_warehouse()
    ]
  end
end

defmodule Zalora.Order do
  alias Zalora.Client
  alias Zalora.MapHelper

  @order_by_fields ["created_at", "updated_at"]

  @order_directions ["asc", "desc"]

  @doc """

  https://sellercenter-api.zalora.com.ph/docs/#/Orders/get_v2_orders
  """
  @get_orders_schema %{
    limit: [type: :integer, required: true],
    offset: [type: :integer, required: true],
    section: [type: :string, in: Zalora.Order.OrderSection.enum()],
    date_start: Date,
    date_end: Date,
    order_numbers: {:array, :string},
    packed: [type: :string, in: Zalora.Order.OrderPacked.enum()],
    customers: {:array, :string},
    printed_status: :boolean,
    tags: {:array, :string},
    product_sku: {:array, :string},
    delivery: [type: :string, in: Zalora.Order.OrderDelivery.enum()],
    shipment_type: [type: :string, in: Zalora.Order.ShipmentType.enum()],
    shipment_providers: {:array, :string},
    payment_methods: {:array, :string},
    outlet: :boolean,
    invoice_required: :boolean,
    cancelation_reasons: :boolean,
    fulfilment_type: [type: {:array, :string}, each: [in: Zalora.Order.FulfillmentType.enum()]],
    order_sources: {:array, :string},
    seller_names: {:array, :string},
    update_date_start: Date,
    update_date_end: Date,
    warehouses: {:array, :string},
    order: [type: :string, in: @order_by_fields],
    order_dir: [type: :string, in: @order_directions],
    order_ids: {:array, :integer}
  }
  def get_orders(params, opts \\ []) do
    with {:ok, query} <- Contrak.validate(params, @get_orders_schema),
         {:ok, client} <- Client.new(opts) do
      query =
        query
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

      client
      |> Client.get("/v2/orders", query: query)
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
  @packed_order_item_schema %{
    order_item_id: [type: :integer, required: true],
    serial_number: :string
  }

  @pack_order_schema %{
    order_items: [type: {:array, @packed_order_item_schema}, required: true],
    delivery_type: [type: :string, required: true, in: Zalora.Order.OrderDeliveryType.enum()],
    shipping_provider: :string,
    tracking_number: :string
  }
  def pack_order(params, opts \\ []) do
    with {:ok, body} <- Contrak.validate(params, @pack_order_schema),
         {:ok, client} <- Client.new(opts) do
      body =
        body
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

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
    order_ids: [type: {:array, :integer}, required: true, length: [min: 1]],
    document_type: [type: :string, in: Zalora.Order.OrderDocumentType.enum(), required: true]
  }
  def export_document(params, opts \\ []) do
    with {:ok, body} <- Contrak.validate(params, @export_document_schema),
         {:ok, client} <- Client.new(opts) do
      body =
        body
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

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

  @doc """
  Set to ready to ship

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/post_v2_orders_statuses_set_to_ready_to_ship
  """
  @ready_to_ship_items_schema %{
    id: [type: :integer, required: true],
    serial_number: :string
  }

  @ready_to_ship_schema %{
    order_items: [type: {:array, @ready_to_ship_items_schema}, required: true],
    delivery_type: [type: :string, in: Zalora.Order.OrderDeliveryType.enum()],
    shipping_provider: :string,
    tracking_number: [type: :string, required: true],
    access_key: :string,
    document_url: :string,
    invoice_encoded_xml: :string
  }
  def ready_to_ship(params, opts \\ []) do
    with {:ok, body} <- Contrak.validate(params, @ready_to_ship_schema),
         {:ok, client} <- Client.new(opts) do
      body =
        body
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

      client
      |> Client.post("v2/orders/statuses/set-to-ready-to-ship", body)
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
  Set tracking number

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Orders/post_v2_order_item_tracking_code
  """
  @tracking_code_schema %{
    order_item_id: [type: :integer, required: true],
    tracking_code: [type: :string, required: true]
  }
  def set_tracking_code(params, opts \\ []) do
    with {:ok, body} <- Contrak.validate(params, @tracking_code_schema),
         {:ok, client} <- Client.new(opts) do
      body =
        body
        |> MapHelper.clean_nil()
        |> MapHelper.to_request_data()

      client
      |> Client.post("v2/order-item/tracking-code", body)
      |> case do
        {:ok, _} = result ->
          result

        error ->
          error
      end
    end
  end
end
