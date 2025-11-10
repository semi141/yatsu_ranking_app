Rails.application.routes.draw do
  get "home/index"

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :videos, only: [:index, :show] do
    resources :posts, only: [:new, :create]
  end

  resources :posts, only: [:edit, :update, :destroy]

  root "home#index"

  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
