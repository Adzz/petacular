defmodule Petacular.Pet do
  use Ecto.Schema

  schema "pets" do
    field(:name, :string)
    has_many(:preferences, Petacular.Preference)
    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(attrs, [:name])
    |> Ecto.Changeset.validate_required([:name])
  end
end
