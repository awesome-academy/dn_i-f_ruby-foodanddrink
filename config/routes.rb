Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users

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
      resources :products do
        member do
          delete :remove_image
        end
      end
    end
    root "products#home"

    get "/home", to: "products#home"
    get "/show/:id", to: "order_details#show"
    delete "/cart/:id", to: "carts#destroy"
    get "/users/:id", to: "users#show", as: "user_show"

    as :user do
      get "login", to: "devise/sessions#new"
      get "signup", to: "devise/registrations#new"
      delete "signout", to: "devise/sessions#destroy"
    end
    resources :products
    resources :carts
  end
end
