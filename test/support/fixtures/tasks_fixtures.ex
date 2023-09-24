defmodule TodoApi.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApi.Tasks` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        deadline: ~D[2023-09-23],
        completed: true
      })
      |> TodoApi.Tasks.create_todo()

    todo
  end
end
