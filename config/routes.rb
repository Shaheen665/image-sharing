Rails.application.routes.draw do
  devise_for :users
  root 'conversations#index'
  resources :users, only: [:index]
  resources :personal_messages, only: [:new, :create]
  resources :conversations, only: [:index, :show]
  mount ActionCable.server => '/cable'
end
