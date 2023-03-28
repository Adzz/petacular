defmodule PetacularWeb.HomeLive do
  @moduledoc """

  """
  use PetacularWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="font-semibold text-3xl mb-4">Pets</h1>
    <PetacularWeb.CoreComponents.button>
      Add New Pet +
    </PetacularWeb.CoreComponents.button>
    """
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")
    {:noreply, socket}
  end
end
