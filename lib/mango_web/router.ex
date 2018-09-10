defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MangoWeb.Plugs.LoadCustomer
    plug MangoWeb.Plugs.FetchCart  
  end

  pipeline :frontend do
  # Add plugs related to frontend
    plug MangoWeb.Plugs.LoadCustomer
    plug MangoWeb.Plugs.FetchCart
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Unauthenticated scope
  scope "/", MangoWeb do
    pipe_through [:browser, :frontend]
    # Add all routes for unauthenticated users
  end

  # Authenticated scope
  scope "/", MangoWeb do
    pipe_through [:browser, :frontend, MangoWeb.Plugs.AuthenticateCustomer]
    # Add routes that require authentication
    get "/logout", SessionController, :delete
    get "/checkout", CheckoutController, :edit
    put "/checkout/confirm", CheckoutController, :update
  end

  scope "/", MangoWeb do
    pipe_through [:browser, :frontend] # Use the default browser stack

    get "/", PageController, :index
    get "/categories/:name", CategoryController, :show

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/login", SessionController, :new 
    post "/login", SessionController, :create 

    post "/cart", CartController, :add
    get "/cart", CartController, :show
    put "/cart", CartController, :update

  end

  # Other scopes may use custom stacks.
  # scope "/api", MangoWeb do
  #   pipe_through :api
  # end
end
