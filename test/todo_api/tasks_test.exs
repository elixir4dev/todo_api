defmodule TodoApi.TasksTest do
  use TodoApi.DataCase

  alias TodoApi.Tasks

  describe "todos" do
    alias TodoApi.Tasks.Todo

    import TodoApi.TasksFixtures

    @invalid_attrs %{description: nil, title: nil, deadline: nil, completed: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Tasks.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Tasks.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{description: "some description", title: "some title", deadline: ~D[2023-09-19], completed: true}

      assert {:ok, %Todo{} = todo} = Tasks.create_todo(valid_attrs)
      assert todo.description == "some description"
      assert todo.title == "some title"
      assert todo.deadline == ~D[2023-09-19]
      assert todo.completed == true
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", deadline: ~D[2023-09-20], completed: false}

      assert {:ok, %Todo{} = todo} = Tasks.update_todo(todo, update_attrs)
      assert todo.description == "some updated description"
      assert todo.title == "some updated title"
      assert todo.deadline == ~D[2023-09-20]
      assert todo.completed == false
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_todo(todo, @invalid_attrs)
      assert todo == Tasks.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Tasks.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Tasks.change_todo(todo)
    end
  end
end
