defmodule Zalora.Client do
  alias Zalora.Helpers

  def new(opts \\ []) do
    config = Zalora.Helpers.get_config()

    proxy_adapter =
      if config.proxy do
        [proxy: config.proxy]
      else
        nil
      end

    api_url = opts[:api_url] || config.api_url
    # access_token = opts[:access_token]

    if is_nil(api_url) do
      {:error, "Missing api_url in configuration"}
    else
      options = [
        adapter: proxy_adapter
        # access_token: access_token
      ]

      options = Helpers.clean_nil(options)

      middlewares = [
        {Tesla.Middleware.BaseUrl, api_url},
        {Tesla.Middleware.Opts, options},
        # Zalora.Middleware.Authentication,
        Tesla.Middleware.JSON
      ]

      # if config setting timeout, otherwise use default settings
      middlewares =
        if config.timeout do
          [{Tesla.Middleware.Timeout, timeout: config.timeout} | middlewares]
        else
          middlewares
        end

      {:ok, Tesla.client(middlewares ++ config.middlewares)}
    end
  end

  @doc """
  Perform a GET request

    get("/users")
    get("/users", query: [scope: "admin"])
    get(client, "/users")
    get(client, "/users", query: [scope: "admin"])
    get(client, "/users", body: %{name: "Jon"})
  """
  @spec get(Tesla.Client.t(), String.t(), keyword()) :: {:ok, any()} | {:error, any()}
  def get(client, path, opts \\ []) do
    client
    |> Tesla.get(path, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  defp process(response) do
    module =
      Application.get_env(:zalora, :config, [])
      |> Keyword.get(:response_handler, __MODULE__)

    module.handle_response(response)
  end

  @doc """
  Default response handler for request, user can customize by pass custom module in config
  """
  def handle_response(response) do
    case response do
      {:ok, %{body: body, status: 200}} ->
        {:ok, body}

      {:ok, %{body: body}} ->
        {:error, body}

      {_, _result} ->
        {:error, %{type: :system_error, response: response}}
    end
  end
end
