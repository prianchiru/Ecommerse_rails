Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books
  post 'books/buy', to: 'books#buy'
  post 'books/add', to: 'books#add'
  post 'appliances/buy', to: 'appliances#buy'
  post 'appliances/add', to: 'appliances#add'
  resources :appliances
  resources :users, param: :username
  post 'auth/login', to: 'authentication#login'
  
end
