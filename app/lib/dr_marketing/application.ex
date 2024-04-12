defmodule DrMarketing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DrMarketingWeb.Telemetry,
      DrMarketing.Repo,
      {DNSCluster, query: Application.get_env(:dr_marketing, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DrMarketing.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DrMarketing.Finch},
      # Start a worker by calling: DrMarketing.Worker.start_link(arg)
      # {DrMarketing.Worker, arg},
      # Start to serve requests, typically the last entry
      DrMarketingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DrMarketing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DrMarketingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
