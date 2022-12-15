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
end
