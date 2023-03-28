defmodule Petacular.Preference do
  use Ecto.Schema

  schema "preferences" do
    field(:description, :string)
    belongs_to(:pet, Petacular.Pet)
    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(attrs, [:description, :pet_id])
    |> Ecto.Changeset.validate_required([:description, :pet_id])
  end
end
