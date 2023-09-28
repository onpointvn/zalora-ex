defmodule Zalora.FileManager do
  alias Zalora.Client

  @doc """
  Download file managers

  Reference
  https://sellercenter-api.zalora.com.ph/docs/#/Files/get_filemanager_v1_files_download__uuid_
  """
  @download_manager_file_schema %{
    uuid: :string
  }
  def download_manager_file(params, opts \\ []) do
    with {:ok, %{uuid: uuid}} <- Contrak.validate(params, @download_manager_file_schema),
         {:ok, client} <- Client.new(opts),
         result <-
           Client.get(client, "filemanager/v1/files/download/#{uuid}") do
      result
    else
      {:ok, data} ->
        {:error, data}

      error ->
        error
    end
  end
end
