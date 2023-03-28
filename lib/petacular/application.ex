defmodule Petacular.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PetacularWeb.Telemetry,
      # Start the Ecto repository
      Petacular.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Petacular.PubSub},
      # Start Finch
      {Finch, name: Petacular.Finch},
      # Start the Endpoint (http/https)
      PetacularWeb.Endpoint
      # Start a worker by calling: Petacular.Worker.start_link(arg)
      # {Petacular.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Petacular.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PetacularWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
