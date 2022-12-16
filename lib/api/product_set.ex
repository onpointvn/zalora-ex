defmodule Zalora.ProductSet.Status do
  @moduledoc """
  Zalora product set status

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/ProductSet/get_v2_product_sets
  """
  def active, do: "active"

  def inactive_all, do: "inactive-all"

  def deleted_all, do: "deleted-all"

  def image_missing, do: "image-missing"

  def pending, do: "pending"

  def rejected, do: "rejected"

  def disapproved, do: "disapproved"

  def sold_out, do: "sold-out"

  def not_authorized, do: "not-authorized"

  def best_selling, do: "best-selling"

  def enum do
    [
      active(),
      inactive_all(),
      deleted_all(),
      image_missing(),
      pending(),
      rejected(),
      disapproved(),
      sold_out(),
      not_authorized(),
      best_selling()
    ]
  end

  def filter_enum do
    ["all" | enum()]
  end
end

defmodule Zalora.ProductSet.VisibilityStatus do
  @moduledoc """
  Zalora product set visibility status

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/ProductSet/get_v2_product_sets
  """
  def syncing, do: "Syncing"

  def enum, do: [syncing()]
end

defmodule Zalora.ProductSet.OrderBy do
  @moduledoc """
  Zalora product set order fields

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/ProductSet/get_v2_product_sets
  """
  def created_at, do: "createdAt"

  def enum, do: [created_at()]
end

defmodule Zalora.ProductSet do
  alias Zalora.Client
  alias Zalora.MapHelper

  @doc """
  Get list of product set

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/ProductSet/get_v2_product_sets
  """
  @get_product_sets_schema %{
    limit: [type: :integer, required: true],
    offset: [type: :integer, required: true],
    status: [type: :string, in: Zalora.ProductSet.Status.filter_enum()],
    keyword: :string,
    create_date_start: Date,
    create_date_end: Date,
    update_date_start: Date,
    update_date_end: Date,
    brand_ids: {:array, :integer},
    tags: {:array, :string},
    visibility: [type: :string, in: Zalora.ProductSet.VisibilityStatus.enum()],
    in_stock: :boolean,
    reserved: :boolean,
    category_ids: {:array, :integer},
    only_with_tags: :boolean,
    parent_sku: :string,
    group: :string,
    order_by: [type: :string, in: Zalora.ProductSet.OrderBy.enum()],
    order_direction: [type: :string, in: Zalora.OrderDirection.enum()]
  }
  def get_product_sets(params, opts \\ []) do
    params = MapHelper.clean_nil(params)

    with {:ok, query} <- Contrak.validate(params, @get_product_sets_schema),
         {:ok, client} <- Client.new(opts) do
      query =
        query
        |> MapHelper.clean_nil()
        |> MapHelper.to_query()

      client
      |> Client.get("/v2/product-sets", query: query)
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
end
