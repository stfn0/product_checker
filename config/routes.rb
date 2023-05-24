Rails.application.routes.draw do
  #resources :users, only: [:new, :create]
  resources :products, only: [:create]

  #GET /main
  get "/main", to: "main#index"
  root to: "main#index"
  
  #Adds a product to the DB
  post 'product/create/:url', to: "product#create"

  #User register 
  get "sign_up", to: "registration#new"
  post "sign_up", to: "registration#create"

  #User log on
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  #User log off
  delete "logout", to: "sessions#destroy"

  #Retrieve password
  get "password", to: "passwords#edit", as: :edit_password
  patch "password", to: "passwords#update"

  #Reset password
  get "password/reset", to: "password_resets#new"  
  post "password/reset", to: "password_resets#create"
  
  #Reset password deprecated
  get "password/reset/edit", to: "password_resets#new"  
  patch "password/reset/edit", to: "password_resets#create"
  
  #Dashboard
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  post '/dashboard/add_product', to: 'dashboard#add_product', as: 'add_product'
  
#Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'


end