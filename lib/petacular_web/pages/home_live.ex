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
      edit_form: Phoenix.Component.to_form(Petacular.Pet.create_changeset(%{})),
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
        <div class="flex">
          <button phx-click={open_edit_modal(pet.id, pet.name)}>
            <PetacularWeb.CoreComponents.icon name="hero-pencil-square-solid" class="mr-2" />
          </button>
          <p>Name: <span class="font-semibold"><%= pet.name %></span></p>
        </div>
      <% end %>
    </div>

    <PetacularWeb.CoreComponents.modal id="edit_modal">
      <h2>Edit a pet.</h2>

      <PetacularWeb.CoreComponents.simple_form for={@edit_form} phx-submit="edit_pet">
        <%= Phoenix.HTML.Form.hidden_input(@edit_form, :id, id: "edit_pet_id_input") %>
        <PetacularWeb.CoreComponents.input
          id="edit_name"
          label="Name"
          field={@edit_form[:name]}
          value={@edit_form[:name].value}
        />
        <:actions>
          <PetacularWeb.CoreComponents.button>
            Save
          </PetacularWeb.CoreComponents.button>
        </:actions>
      </PetacularWeb.CoreComponents.simple_form>
    </PetacularWeb.CoreComponents.modal>

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

  defp open_edit_modal(pet_id, pet_name) do
    %JS{}
    |> JS.push("open_edit_modal", value: %{pet_id: pet_id})
    |> JS.set_attribute({"value", pet_name}, to: "#edit_name")
    |> JS.set_attribute({"value", pet_id}, to: "#edit_pet_id_input")
    |> PetacularWeb.CoreComponents.show_modal("edit_modal")
  end

  @impl true
  def handle_event("create_pet", %{"pet" => params}, socket) do
    case Repo.insert(Petacular.Pet.create_changeset(params)) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        new_assigns = %{
          pets: Repo.all(Petacular.Pet),
          create_form: Phoenix.Component.to_form(Petacular.Pet.create_changeset(%{}))
        }

        socket =
          socket
          |> assign(new_assigns)
          |> push_event("close_modal", %{to: "#close_modal_btn_create_modal"})

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("edit_pet", %{"pet" => %{"id" => id} = params}, socket) do
    pet = Enum.find(socket.assigns.pets, &(&1.id == String.to_integer(id)))

    case Repo.insert(Petacular.Pet.edit_changeset(params, pet)) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        new_assigns = %{
          pets: Repo.all(Petacular.Pet),
          edit_form: Phoenix.Component.to_form(Petacular.Pet.create_changeset(%{}))
        }

        socket =
          socket
          |> assign(new_assigns)
          |> push_event("close_modal", %{to: "#close_modal_btn_edit_modal"})

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("open_edit_modal", %{"pet_id" => id}, socket) do
    pet = Enum.find(socket.assigns.pets, &(&1.id == id))

    new_assigns = %{
      edit_form: Phoenix.Component.to_form(Petacular.Pet.edit_changeset(%{}, pet))
    }

    {:noreply, assign(socket, new_assigns)}
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")
    {:noreply, socket}
  end
end
