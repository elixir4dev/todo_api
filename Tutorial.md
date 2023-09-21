# Build a TODO List REST API with Elixir and Phoenix.
To build a REST API for a TODO list app in Elixir and Phoenix, you can follow these steps:

## Prerequisites
  - Elixir  15.5
  - Erlang  OTP 26
  - Database: PostgreSQL 

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
   mix phx.new todo_api

This will generate the basic structure of a Phoenix project, including configuration files, a supervision tree, and an initial endpoint.
For now we will use this approach but it will install a few things that are not required for a JSON API.

## Create the Database
Configure your database (by default PostgreSQL) in the file `config/dev.exs` optionally `config/test.exs` if you want to run the test cases. 
You will need to have a database installed or use a Docker container with PostgreSQL.

Create the database with the command 
    mix ecto.create

Your will see a message like this

`The database for TodoApi.Repo has been created`

From the command line vavigate to the project directory with the command cd todo_api and start the Phoenix server with the command `mix phx.server`. 

You should be able to access the default Phoenix welcome page by opening your web browser and navigating to http://localhost:4000.

## Create the API Controller, JSON view and context 

We are going to create a `Todo` schema inside a context named `Tasks`. Add the following attributes as fields inside the Todo schema:

- A title for the task
- A description of the task
- A boolean flag to indicate if the task is completed or not
- A deadline for the task

Execute the following command

`mix phx.gen.json Tasks Todo todos title:string description:string completed:boolean deadline:date`

This command it's a generator that creates a JSON-based API for a resource named `Todo` inside a context named `Tasks`.  We will see another approach to build
an API at the end. A context is a module that groups related functionality and serves as an interface to the data layer.

The first argument is the context module followed by the schema module and its
plural name (used as the schema table name).

The context is an Elixir module that serves as an API boundary for the given
resource. A context often holds many related resources. Therefore, if the
context already exists, it will be augmented with functions for the given
resource.

The schema is responsible for mapping the database fields into an Elixir
struct. It is followed by an optional list of attributes, with their respective
names and types. See `mix help phx.gen.schema` for more information on attributes.

Overall, this generator will add the following files to lib/:

  - a context module in lib/todo_api/tasks.ex for the Todo API
  - a schema in lib/todo_api/todo.ex, with a todos table
  - a controller in lib/todo_api_web/controllers/todo_controller.ex
  - a JSON view collocated with the controller in
    lib/todo_Api_web/controllers/todo_json.ex

A migration file for the repository and test files for the context and
controller features will also be generated.

To learn more about it run the command `mix help phx.gen.json`

## Update the router
Add the resource to your :api scope in `lib/todo_api_web/router.ex:`

```
  scope "/api", TodoApiWeb do
     pipe_through :api

     resources "/todos", TodoController, except: [:new, :edit]
  end
```

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

## API testing

Test the API with Postman, https://hoppscotch.io/ or any other API client 

  - GET     /api/todos                  TodoApiWeb.TodoController :index
  - GET     /api/todos/:id              TodoApiWeb.TodoController :show
  - POST    /api/todos                  TodoApiWeb.TodoController :create
  - PATCH   /api/todos/:id              TodoApiWeb.TodoController :update
  - PUT     /api/todos/:id              TodoApiWeb.TodoController :update
  - DELETE  /api/todos/:id              TodoApiWeb.TodoController :delete

### Using CURL to test the API

To get a list of all todos, you can use this command:

  curl -X GET http://localhost:4000/api/todos

To get a specific todo by its id, you can use this command (replace :id with the actual id):
```
  curl -X GET http://localhost:4000/api/todos/:id
```
To create a new todo with the given JSON body, you can use this command:
```
  curl -X POST -H "Content-Type: application/json" -d '{"todo": {"title": "Learn Elixir", "description": "A functional programming language", "completed": false, "deadline": "2023-09-30"}}' http://localhost:4000/api/todos
```
To update an existing todo by its id with the given JSON body, you can use this command (replace :id with the actual id):
```
  curl -X PATCH -H "Content-Type: application/json" -d '{"todo": {"title": "Learn Elixir", "description": "A functional programming language", "completed": false, "deadline": "2023-09-30"}}' http://localhost:4000/api/todos/:id
```
To delete an existing todo by its id, you can use this command (replace :id with the actual id):
```
   curl -X DELETE http://localhost:4000/api/todos/:id
```
 ## Create a new course (Postman or https://hoppscotch.io/)
 ```POST http://localhost:4000/api/todos  Content-Type application/json

  {
    title: "Learn Elixir",
    description: "Learn Elixir Fundamentals",
    completed: false,
    deadline: ~D[2023-09-25]
  }
```
## Get all courses 

`GET http://localhost:4000/api/todos`

## Notes

if you want to start with a fresh database run

    mix ecto.reset


## Improvements
Now that we know the basics we can redo our project using a better approach to build the Phoenix project

```
   mix phx.new project_name --no-install --app project_name --database postgres --no-live --no-assets --no-html --no-dashboard --no-mailer 
```
 - `--no-install` 
    - do not fetch and install the dependencies automatically. You will need to run mix deps.get manually after creating the project1.
 - `--app project_name` 
    - specify the name of the OTP application. This will also be used as the module name for the generated skeleton1.
 - `--database postgres` 
    - specify the database adapter for Ecto. This will use Postgrex to connect to a PostgreSQL database1.
 - `--no-live` 
    - do not include Phoenix.LiveView, which is a feature that allows you to build interactive, real-time applications12.
 -  `--no-assets` 
    - do not generate any files for static asset building, such as webpack or esbuild. This option is equivalent to --no-esbuild and -  - - --no-tailwind1. You will need to handle JavaScript dependencies manually if you want to use them1.
 - `--no-html` 
    - do not generate any HTML views or templates. This option is useful for API-only applications1.
 - `--no-dashboard` 
    - do not include Phoenix.LiveDashboard, which is a feature that provides real-time performance monitoring and debugging tools for Phoenix applications13.
- `--no-mailer` 
    - do not generate any files for Swoosh mailer, which is a library that allows you to send emails from your Phoenix application14




