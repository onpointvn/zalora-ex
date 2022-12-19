defmodule Zalora.Warehouse do
  alias Zalora.Client

  @doc """
  Get list of warehouse

  Reference

  https://sellercenter-api.zalora.com.ph/docs/#/Warehouse/get_v2_warehouses
  """
  @spec get_warehouses(opts :: Keyword.t()) :: {:ok, list(map())} | {:error, any()}
  def get_warehouses(opts \\ []) do
    with {:ok, client} <- Client.new(opts),
         {:ok, items} when is_list(items) <- Client.get(client, "/v2/warehouses") do
      {:ok, items}
    else
      {:ok, data} ->
        {:error, data}

      error ->
        error
    end
  end
end
