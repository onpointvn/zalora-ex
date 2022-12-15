defmodule Zalora.Token do
  alias Zalora.Client

  @doc """
  Request an access token

  Parameters

  - `client_id[string]`: The client id (required)
  - `client_secret[string]`: The client secret (required)

  Output

  {:ok,
   %{
     "access_token" => "<access token>",
     "expires_in" => 3600,
     "token_type" => "Bearer"
   }}

  Reference

  https://sellercenter-api.zalora.com.ph/docs/
  """
  @request_access_token_schema %{
    client_id: [type: :string, required: true],
    client_secret: [type: :string, required: true]
  }
  @spec request_access_token(params :: map(), opts :: Keyword.t()) ::
          {:ok, map()} | {:error, any()}
  def request_access_token(params, opts \\ []) do
    opts = Keyword.put(opts, :use_form_url_encoded, true)

    with {:ok, payload} <- Contrak.validate(params, @request_access_token_schema),
         {:ok, client} <- Client.new(opts) do
      payload = Map.put(payload, :grant_type, "client_credentials")
      Client.post(client, "/oauth/client-credentials", payload)
    end
  end
end
