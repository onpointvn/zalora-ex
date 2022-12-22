defmodule Zalora.Client do
  @moduledoc """
  Process and sign data before sending to Zalora and process response from Zalora server
  Proxy could be config
    config :zalora, :config,
      proxy: "http://127.0.0.1:9090",
      api_url: "",
      timeout: 10_000,
      response_handler: MyModule,
      middlewares: [] # custom middlewares
  Your custom reponse handler module must implement `handle_response/1`
  """

  @doc """
  Create a new client with given API information.
  API information can be set using config.
    config :zalora, :config,
      api_url: "",
      timeout: 60,
      middlewares: []

  Or could be pass via `opts` argument

  **Options**
  - `api_url[string]`: The API URL
  - `use_form_url_encoded[boolean]`: Make the API client uses form URL encoded content type to post payload.
  - `access_token[string]`: Make the API client decorates access token for each request.
  """
  @spec new(opts :: Keyword.t()) :: {:ok, Tesla.Client.t()} | {:error, String.t()}
  def new(opts \\ []) do
    config = Zalora.Helpers.get_config()

    proxy_adapter =
      if config.proxy do
        [proxy: config.proxy]
      else
        nil
      end

    api_url = opts[:api_url] || config.api_url
    access_token = opts[:access_token]

    if is_nil(api_url) do
      {:error, "Missing api_url in configuration"}
    else
      options = [
        adapter: proxy_adapter,
        access_token: access_token
      ]

      options = Zalora.MapHelper.clean_nil(options)

      middlewares = [
        {Tesla.Middleware.BaseUrl, api_url},
        {Tesla.Middleware.Opts, options},
        Zalora.Middleware.Authentication
      ]

      middlewares =
        if opts[:use_form_url_encoded] == true do
          middlewares ++ [Tesla.Middleware.FormUrlencoded]
        else
          middlewares
        end

      # For extracting response
      middlewares = middlewares ++ [Tesla.Middleware.JSON]

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

  @doc """
  Perform a PUT request.

    put("/users", [%{name: "Jon"}])
    put("/users", [%{name: "Jon"}], query: [scope: "admin"])
    put(client, "/users", [%{name: "Jon"}])
    put(client, "/users", [%{name: "Jon"}], query: [scope: "admin"])
  """
  @spec put(Tesla.Client.t(), String.t(), any(), keyword()) :: {:ok, any()} | {:error, any()}
  def put(client, path, body, opts \\ []) do
    client
    |> Tesla.put(path, body, [{:opts, [api_name: path]} | opts])
    |> process()
  end

  @doc """
  Perform a POST request.

    post("/users", %{name: "Jon"})
    post("/users", %{name: "Jon"}, query: [scope: "admin"])
    post(client, "/users", %{name: "Jon"})
    post(client, "/users", %{name: "Jon"}, query: [scope: "admin"])
  """
  @spec post(Tesla.Client.t(), String.t(), any(), keyword()) :: {:ok, any()} | {:error, any()}
  def post(client, path, body, opts \\ []) do
    client
    |> Tesla.post(path, body, [{:opts, [api_name: path]} | opts])
    |> process()
  end
end
