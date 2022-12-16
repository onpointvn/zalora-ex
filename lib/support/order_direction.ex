defmodule Zalora.OrderDirection do
  @moduledoc """
  Enumeration for order directions
  """
  def asc, do: "ASC"

  def desc, do: "DESC"

  def enum do
    [asc(), desc()]
  end
end
