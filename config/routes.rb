Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    resources :account_activations, only: :edit
    resources :users
    resources :password_resets, only: %i(new create edit update)
    get "contact_pages/home"
    get "contact_pages/help"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    root "contact_pages#home"
  end
end
