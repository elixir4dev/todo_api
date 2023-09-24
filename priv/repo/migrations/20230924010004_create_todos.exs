defmodule TodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string
      add :description, :string
      add :completed, :boolean, default: false, null: false
      add :deadline, :date

      timestamps()
    end
  end
end
