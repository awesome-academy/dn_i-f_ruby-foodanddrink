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
      resources :products, only: %i(index show)
    end
    get "/home", to: "products#home"
    get "/show/:id", to: "order_details#show"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"

    resources :products
  end
end
