defmodule PetacularWeb.HomeLive do
  @moduledoc """

  """
  use PetacularWeb, :live_view
  require Logger
  alias Petacular.Repo

  @impl true
  def mount(_params, _session, socket) do
    default_assigns = %{
      pets: Repo.all(Petacular.Pet),
      create_form: Phoenix.Component.to_form(Petacular.Pet.create_changeset(%{}))
    }

    {:ok, assign(socket, default_assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="font-semibold text-3xl mb-4">Pets</h1>

    <div class="w-50 mb-4">
      <%= for pet <- @pets do %>
        <p>Name: <span class="font-semibold"><%= pet.name %></span></p>
      <% end %>
    </div>

    <PetacularWeb.CoreComponents.modal id="create_modal">
      <h2>Add a pet.</h2>

      <PetacularWeb.CoreComponents.simple_form for={@create_form} phx-submit="create_pet">
        <PetacularWeb.CoreComponents.input field={@create_form[:name]} label="Name" />
        <:actions>
          <PetacularWeb.CoreComponents.button>Save</PetacularWeb.CoreComponents.button>
        </:actions>
      </PetacularWeb.CoreComponents.simple_form>
    </PetacularWeb.CoreComponents.modal>
    <PetacularWeb.CoreComponents.button phx-click={
      PetacularWeb.CoreComponents.show_modal("create_modal")
    }>
      Add New Pet +
    </PetacularWeb.CoreComponents.button>
    """
  end

  @impl true
  def handle_event("create_pet", %{"pet" => params}, socket) do
    case Repo.insert(Petacular.Pet.create_changeset(params)) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        socket =
          socket
          |> assign(%{pets: Repo.all(Petacular.Pet)})
          |> push_event("close_modal", %{to: "#close_modal_btn_create_modal"})

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")
    {:noreply, socket}
  end
end
