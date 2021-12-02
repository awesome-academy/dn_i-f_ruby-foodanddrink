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
    get "/home", to: "products#home"
    get "/show/:id", to: "order_details#show"

    resources :products

  end
end
