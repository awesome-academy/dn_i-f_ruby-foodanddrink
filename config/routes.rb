Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
    end
    get "/home", to: "products#home"
    get "/show/:id", to: "order_details#show"
    get "/new", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete  "/logout", to: "sessions#destroy"
    get "/index", to: "users#index"


    resources :products
    resources :users
  end
end
