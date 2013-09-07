Hedonismbot::Application.routes.draw do
  root to: 'static_pages#index'
  resources :users, except: [:show, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :shows, only: [:create, :destroy]
  resources :trackings, only: [:create, :destroy]
  get '/about' => "static_pages#about", as: "about"
  get '/signup' => "users#new", as: "signup"
  get '/signup' => "sessions#new", as: "login"
  get '/logout' => "sessions#destroy", as: "logout"
end
