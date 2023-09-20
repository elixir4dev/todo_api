# Build a TODO List REST API with Elixir and Phoenix.
To build a REST API for a TODO list app in Elixir and Phoenix, you can follow these steps:

## Prerequisites
  - Elixir  15.5
  - Erlang  OTP 26
  - Database: PostgreSQL 

Check the current version of Elixir: 

`elixir -v`

## Install Hex

 `mix local.hex`
[Hex](https://hex.pm/) is a package manager for the Erlang ecosystem, which includes Elixir. 
Hex allows you to fetch, manage, and publish packages from a central repository. 
 
## Install Phoenix
Check if Phoenix is installed `mix phx.new --version`

 `mix archive.install hex phx_new`

## Create a new Phoenix Project

`mix phx.new todo_api`

This will generate the basic structure of a Phoenix project, including configuration files, a supervision tree, and an initial endpoint.

## Create the Database
Configure your database (by default PostgreSQL) in the file `config/dev.exs` optionally `config/test.exs` if you want to run the test cases. 
You will need to have a database installed or use a Docker container with PostgreSQL.

Create the database with the command 
`mix ecto.create`

Your will see a message like this

`The database for TodoApi.Repo has been created`

From the command line vavigate to the project directory with the command cd todo_api and start the Phoenix server with the command mix phx.server. 

You should be able to access the default Phoenix welcome page by opening your web browser and navigating to http://localhost:4000.

## Create the API Controller, JSON view and context 

We are going to create a Todo schema inside a context named Tasks. Add the following attributes as fields inside the Todo schema:

- A title for the task
- A description of the task
- A boolean flag to indicate if the task is completed or not
- A deadline for the task

Execute the following command

`mix phx.gen.json Tasks Todo todos title:string description:string completed:boolean deadline:date`

This command it's a generator that creates a JSON-based API for a resource named `Todo` inside a context named `Tasks`. A context is a module that groups related functionality and serves as an interface to the data layer.

The first argument is the context module followed by the schema module and its
plural name (used as the schema table name).

The context is an Elixir module that serves as an API boundary for the given
resource. A context often holds many related resources. Therefore, if the
context already exists, it will be augmented with functions for the given
resource.

The schema is responsible for mapping the database fields into an Elixir
struct. It is followed by an optional list of attributes, with their respective
names and types. See mix phx.gen.schema for more information on attributes.

Overall, this generator will add the following files to lib/:

  • a context module in lib/todo_api/tasks.ex for the Todo API
  • a schema in lib/todo_api/todo.ex, with a todos table
  • a controller in lib/todo_api_web/controllers/todo_controller.ex
  • a JSON view collocated with the controller in
    lib/todo_Api_web/controllers/todo_json.ex

A migration file for the repository and test files for the context and
controller features will also be generated.

To learn more about it run the command `mix help phx.gen.json`
## Update the router
Add the resource to your :api scope in `lib/todo_api_web/router.ex:``

```
    resources "/todos", TodoController, except: [:new, :edit]
```

## Update the Database

Run the following command

`mix ecto.migrate`