Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts, only: %i(index create destroy)
    # or resources :microposts, except: %i(index new edit show update)
    resources :users, only: %i(new create show)
    resources :password_resets, only: %i(new create edit update)
    resources :account_activations, only: :edit
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
