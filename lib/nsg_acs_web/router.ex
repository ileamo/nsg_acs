defmodule NsgAcsWeb.Router do
  use NsgAcsWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", NsgAcsWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/users", UserController)
    resources("/session", SessionController, only: [:new, :create, :delete])
    resources("/groups", GroupController)
    resources("/devices", DeviceController)
    resources("/requests", RequestController, only: [:index, :show, :delete])
  end

  scope "/api", NsgAcsWeb.Api, as: :api do
    pipe_through(:api)
    post("/", DeviceController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", NsgAcsWeb do
  #   pipe_through :api
  # end
end
