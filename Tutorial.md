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

## Setting the Database
Configure your database (by default PostgreSQL) in the file `config/dev.exs` optionally `config/test.exs` if you want to run the test cases. 
You will need to have a database installed or use a Docker container with PostgreSQL.

Create the database with the command 
`mix ecto.create`

Your will see a message like this

`The database for TodoApi.Repo has been created`

From the command line vavigate to the project directory with the command cd todo_api and start the Phoenix server with the command mix phx.server. 

You should be able to access the default Phoenix welcome page by opening your web browser and navigating to http://localhost:4000.
