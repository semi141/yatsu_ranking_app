Rails.application.routes.draw do
  get "home/index"

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :videos, only: [:index, :show] do
    collection do
      post :import_jaru_videos
    end

    resources :posts, only: [:new, :create]
  end

  resources :posts, only: [:edit, :update, :destroy]

  namespace :api do
    post 'video_watched', to: 'video_watched#create'
  end

  root "home#index"

  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
