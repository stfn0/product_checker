Rails.application.routes.draw do
  #resources :users, only: [:new, :create]

  #GET /main
  #get "/main", to: "main#index"
  root to: "main#index"
  
  #Adds a product to the DB
  post 'product/create/:url', to: "product#create"

  #User register 
  get "sign_up", to: "registration#new"
  post "sign_up", to: "registration#create"


  # get 'product/index' 
  # get 'product/show'

  # get 'product/new'
  # get 'product/create'


  # get 'product/edit'
  # get 'product/update'

  # get 'product/destroy'


  

end
