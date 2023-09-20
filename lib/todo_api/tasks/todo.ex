defmodule TodoApi.Tasks.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :description, :string
    field :title, :string
    field :deadline, :date
    field :completed, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :completed, :deadline])
    |> validate_required([:title, :description, :completed, :deadline])
  end
end
