Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    get "contact_pages/home"
    get "contact_pages/help"
  end
end
