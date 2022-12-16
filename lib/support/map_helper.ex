defmodule Zalora.MapHelper do
  @doc """
  Clean nil value from map/list recursively

  Example:

  iex> clean_nil(%{a: 1, b: nil, c: [1, 2, nil]})
    %{a: 1, c: [1, 2]}
  """
  @spec clean_nil(map() | list()) :: map()
  def clean_nil(%{__struct__: mod} = param) when is_atom(mod) do
    param
  end

  def clean_nil(%{} = param) do
    Enum.reduce(param, %{}, fn
      {_key, nil}, acc ->
        acc

      {key, value}, acc ->
        Map.put(acc, key, clean_nil(value))
    end)
  end

  def clean_nil(param) when is_list(param) do
    param
    |> Enum.reduce([], fn item, acc ->
      case item do
        nil ->
          acc

        # handle keyword list
        {_, nil} ->
          acc

        _ ->
          [clean_nil(item) | acc]
      end
    end)
    |> Enum.reverse()
  end

  def clean_nil(param), do: param

  @doc """
  Convert map to request query
  """
  def to_query(%Date{} = date) do
    Date.to_iso8601(date)
  end

  def to_query(values) when is_list(values) do
    Enum.join(values, ",")
  end

  def to_query(map) when is_map(map) do
    Enum.into(map, %{}, fn {key, value} ->
      key = Zalora.StringHelper.camelize("#{key}")
      {key, to_query(value)}
    end)
  end
end
