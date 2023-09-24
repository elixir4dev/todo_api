defmodule TodoApiWeb.Router do
  use TodoApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TodoApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodoApiWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/todos", TodoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoApiWeb do
  #   pipe_through :api
  # end
end
