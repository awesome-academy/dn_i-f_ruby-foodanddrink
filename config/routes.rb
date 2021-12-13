Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
      resources :orders do
        member do
          put :approve
          put :reject
        end
      end
    end
    namespace :admin do
      resources :products, except: :delete do
        member do
          delete :remove_image
        end
      end
    end
    root "products#home"

    get "/home", to: "products#home"
    get "/show/:id", to: "order_details#show"
    get "/new", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    delete "/cart/:id", to: "carts#destroy"

    resources :products
    resources :orders
    resources :carts
  end
end
