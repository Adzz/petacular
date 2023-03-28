defmodule Petacular.Repo.Migrations.CreatePetsAndPreferences do
  use Ecto.Migration

  def change do
    create(table(:pets)) do
      add(:name, :text, null: false)
      timestamps()
    end

    create(table(:preferences)) do
      add(:description, :text, null: false)
      add(:pet_id, references(:pets), null: false)
      timestamps()
    end
  end
end
