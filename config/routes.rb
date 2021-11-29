Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
    end
    get "/home", to: "products#home"
  end
end
