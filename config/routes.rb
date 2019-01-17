Rails.application.routes.draw do
  get 'waiting', to: 'static_pages#waiting'
  get '/game_size', to: 'static_pages#game_size'
  get '/rule', to: 'static_pages#rule'
  get '/leaderboard', to: 'static_pages#leaderboard'
  resources :games, only: [:show, :index, :create, :update]
  resources :sessions, only: [:new, :create, :index]
  resource :session, only: [:destroy]
  resources :users
  root'sessions#new'
end
