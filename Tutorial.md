# Build a TODO List REST API with Elixir and Phoenix.
To build a REST API for a TODO list app in Elixir and Phoenix, you can follow these steps:

In this version will will generate the basic structure of a Phoenix project targeting an HTML API. This is better than the generic approach `mix phx.new todo_api`  used before when you only want to create a simple HTML-based resource.


## Prerequisites
  - Elixir  15.5
  - Erlang  OTP 26
  - Database: PostgreSQL 

Check the following [guide](https://github.com/elixir4dev/PostgresDocketContainer) to install Docker desktop and getting a local container with PostgreSQL 


Check the current version of Elixir: 
    elixir -v

## Install Hex
    mix local.hex

[Hex](https://hex.pm/) is a package manager for the Erlang ecosystem, which includes Elixir. 
Hex allows you to fetch, manage, and publish packages from a central repository. 
 
## Install Phoenix
Check if Phoenix is installed 
      phx.new --version

If it's not installed install it with the following command

     mix archive.install hex phx_new

## Create a new Phoenix Project
     mix phx.new todo_api --no-install --app todo_api --database postgres --no-live  --no-dashboard --no-mailer 


Command options overview 
 - `--no-install` 
    - do not fetch and install the dependencies automatically. You will need to run mix deps.get manually after creating the project1.
 - `--app project_name` 
    - specify the name of the OTP application. This will also be used as the module name for the generated skeleton1.
 - `--database postgres` 
    - specify the database adapter for Ecto. This will use Postgrex to connect to a PostgreSQL database1.
 - `--no-live` 
    - do not include Phoenix.LiveView, which is a feature that allows you to build interactive, real-time applications12.
  - `--no-dashboard` 
    - do not include Phoenix.LiveDashboard, which is a feature that provides real-time performance monitoring and debugging tools for Phoenix applications13.
- `--no-mailer` 
    - do not generate any files for Swoosh mailer, which is a library that allows you to send emails from your Phoenix application14


This will generate the basic structure of a Phoenix project. This is better than the generic approach `mix phx.new todo_api`  used before when you only want to create a REST API using Phoenix and don’t need LiveView, assets, HTML, dashboard, or mailer. It helps you avoid generating unnecessary files and dependencies that are not required for an API-only application. This can save you time and reduce the complexity of your project by keeping it focused on the essentials.

## Fetch the dependencies

    mix.deps.get

## Create the Database
Configure your database (by default PostgreSQL) in the file `config/dev.exs` optionally `config/test.exs` if you want to run the test cases. 
You will need to have a database installed or use a Docker container with PostgreSQL.

Create the database with the command 
    mix ecto.create

Your will see a message like this

`The database for TodoApi.Repo has been created`

From the command line vavigate to the project directory with the command cd todo_api and start the Phoenix server with the command `mix phx.server`.
Now you will get a 404 


## Create the Schema

We are going to create a `Todo` schema inside a context named `Tasks`. Add the following attributes as fields inside the Todo schema:

- A title for the task
- A description of the task
- A boolean flag to indicate if the task is completed or not
- A deadline for the task

Execute the following command

`mix phx.gen.context Tasks Todo todos title:string description:string completed:boolean deadline:date`

The command generates a **context** with functions around an **Ecto schema**. The first argument is the context module followed by the schema module and its plural name (used as the schema table name). The context is an Elixir module that serves as an API boundary for the given resource¹. It adds the following files to `lib/todo_api`:
- A context module in `tasks.ex`, serving as the API boundary.
- A schema in `tasks/todo.ex`, with a `todos` table.
- A migration file for the repository and test files for the context will also be generated¹.

This generator will prompt you if there is an existing context with the same name, in order to provide more instructions on how to correctly use Phoenix contexts¹. You can skip this prompt and automatically merge the new schema access functions and tests into the existing context using `--merge-with-existing-context`. To prevent changes to the existing context and exit the generator, use `--no-merge-with-existing-context`¹.


To learn more about it run the command `mix help phx.gen.context`


## Migrate the changes to the Repository
After creating the schema, it is time to migrate the changes to the repository. We are going to seed the database with dummy data.
This will enable us to test our API

 - Update the /priv/repo/seeds.exs file with dummy records

    ```
    TodoApi.Repo.insert!(%TodoApi.Tasks.Todo{
      title: "Buy groceries",
      description: "Milk, eggs, bread, cheese, apples, bananas",
      completed: false,
      deadline: ~D[2023-09-25]
    })

    TodoApi.Repo.insert!(%TodoApi.Tasks.Todo{
      title: "Finish homework",
      description: "Math, English, History",
      completed: true,
      deadline: ~D[2023-09-20]
    })

    TodoApi.Repo.insert!(%TodoApi.Tasks.Todo{
      title: "Call mom",
      description: "Wish her happy birthday",
      completed: false,
      deadline: ~D[2023-09-22]
    })
    ```

  - Check test cases /test/todo_api/tasks_test.exs file that contains a few tests for the context that was created previously.

### Run the migrations

    mix.ecto migrate
    
### Seed the database using the relevant file
    mix run priv/repo/seeds.exs
    
### Test that everything works as intended
    
    mix test


## Create the Controller for HTML resources
In the other approach we didn't need to create the controller because we use  `mix phx.gen.json` and it generates everything for us.
The context module `tasks.ex`, the schema `todo.ex`, the controller `todo_controller.ex` and the JSON view `todo_json.ex` 

So now we will create a simple JSON-based API to perform CRUD operations. Running the following command.

`mix phx.gen.html Tasks Todo todos title:string description:string completed:boolean deadline:date --no-context --no-schema`

As you can see, this is quite similar to the command that we run in our first approach. But we have two additional flags.
The `--no-schema` flag is used to skip generating an Ecto schema for the resource. This means that the generated code will not include a database table or migration file. It can be useful when you want to create a JSON API without persisting data in a database or when you have already it in place.

The `--no-context` flag is used to skip generating a context module for the resource. The context module serves as an API boundary and provides functions for working with the resource2. By skipping the context generation, you have more flexibility in how you structure your application and handle the resource’s logic.

Using these flags allows you to generate only the necessary files for an HTML resource, without generating additional files and dependencies that are not required for your specific use case, or you have already done it.

After we run the command we see the following message.

Add the resource to your browser scope in lib/todo_api_web/router.ex:

    resources "/todos", TodoController

So you will need to update the router to have

```
  scope "/", TodoApiWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/todos", TodoController
  end
```
So now we need to verify that everything is ok.

Run the test cases

    mix test

## How to avoid duplicated entries

Verify what happends when we add duplicated entries.
Add the following test case to the test cases `test/todo_api/tasks_test.exs`

```
    test "create_tast/1 with duplicate data returns error" do
     valid_attrs = %{description: "some description", title: "some title", deadline: ~D[2023-09-19], completed: true}

      assert {:ok, %Todo{} = todo} = Tasks.create_todo(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Tasks.create_todo(valid_attrs)
    end
```

### Run the test cases

    mix test

Since we are not handling duplicate entires we expect to have a test case failure

```
  1) test todos create_tast/1 with duplicate data returns error (TodoApi.TasksTest)
     test/todo_api/tasks_test.exs:65
     match (=) failed
     code:  assert {:error, %Ecto.Changeset{}} = Tasks.create_todo(valid_attrs)
     left:  {:error, #Ecto.Changeset<action: nil, changes: %{}, errors: [], data: nil, valid?: false>}
     right: {
              :ok,
              %TodoApi.Tasks.Todo{__meta__: #Ecto.Schema.Metadata<:loaded, "todos">, id: 40, description: "some description", title: "some title", deadline: ~D[2023-09-19], completed: true, inserted_at: ~N[2023-09-21 11:56:54], updated_at: ~N[2023-09-21 11:56:54]}
            }
     stacktrace:
       test/todo_api/tasks_test.exs:73: (test)


```

Now we need to modify the migration and schema files to ensure that the todo title is unique. 
After that we will verify the fix running the test cases. 

We also need to modify the changeset inside the /lib/todo_api/tasks/todo.ex file

```
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :completed, :deadline])
    |> validate_required([:title, :description, :completed, :deadline])
    |> unique_constraint([:title], message: "Task already exists")
  end
```

## Create a migration 

A migration in Ecto is a way of changing your database structure. You can use Elixir code to create, modify, or drop tables, columns, indexes, and more. Migrations are stored in files under `priv/repo/migrations`, and each file has a name and number. You can run migrations using Mix tasks, such as `mix ecto.migrate` or `mix ecto.rollback`. Migrations help you keep track of your database schema changes and apply them consistently across different environments. Migrations are an essential part of working with Ecto, a powerful tool for interacting with databases in Elixir. To learn more, check out [Ecto.Migration](https://hexdocs.pm/ecto_sql/Ecto.Migration.html) or [Ecto.Basics](https://elixirschool.com/en/lessons/ecto/basics/).


`mix ecto.gen.migration add_unique_index_title_to_tasks`

Add the following code in the function change in the migration file.

```
  create unique_index(:todos, [:title])
```

The file will looks like this

```
defmodule TodoApi.Repo.Migrations.AddUniqueIndexTitleToTasks do
  use Ecto.Migration

  def change do
    create unique_index(:todos, [:title])
  end
end

```
Before we need to apply the migration running the following command
    mix.ecto.migrate

We can wow you can run the test cases
    mix test

Now all the test cases should pass.

To get a list of all todos, you can use this command:

## Run the Application 

Open your browser and test the app.

## Notes

if you want to start with a fresh database run

    mix ecto.reset

