Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users
  
  # Convenience redirects for authentication
  get '/signup', to: redirect('/users/sign_up')
  get '/login', to: redirect('/users/sign_in')
  
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "tops#top"
  
  # Application routes
  get "home", to: "homes#index"
  resources :posts do
    collection do
      get 'drafts'
    end
    resource :favorite, only: [:create, :destroy]
  end
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
end
