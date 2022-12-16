defmodule Zalora.StringHelper do
  @doc """
  Convert string from snake case to camel case
  """
  @spec camelize(value :: String.t() | atom()) :: String.t()
  def camelize(value) do
    value = "#{value}"

    value
    |> String.split("_")
    |> Enum.reduce(nil, fn
      item, nil ->
        [item]

      item, acc ->
        [String.capitalize(item) | acc]
    end)
    |> Enum.reverse()
    |> Enum.join()
  end
end
