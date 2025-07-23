Rails.application.routes.draw do
  get 'posts/new'
  get 'posts/create'
  get 'homes/index'
  devise_for :users
  get '/signup', to: redirect('/users/sign_up')
  get '/login', to: redirect('/users/sign_in')
  get 'posts/index'
  get 'posts/show'
  get 'posts/new'
  get 'posts/edit'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "tops#top"
  get "home", to: "homes#index"

  resources :posts
end
