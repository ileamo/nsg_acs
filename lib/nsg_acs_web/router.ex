defmodule NsgAcsWeb.Router do
  use NsgAcsWeb, :router
  import NsgAcs.Guard, only: [load_current_user: 2]

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

  pipeline :auth do
    plug(NsgAcs.Guard.AuthAccessPipeline)
    plug :load_current_user
  end

  scope "/", NsgAcsWeb do
    pipe_through([:browser])

    resources("/session", SessionController, only: [:new, :create])
  end

  scope "/", NsgAcsWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    get("/discovery", PageController, :discovery)
    resources("/users", UserController)
    resources("/session", SessionController, only: [:delete])
    resources("/groups", GroupController)
    resources("/devices", DeviceController)
    resources("/requests", RequestController, only: [:index, :show, :delete])
    resources("/newdevs", NewdevController, only: [:index, :delete, :new, :edit, :update])
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
