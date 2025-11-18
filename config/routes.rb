Rails.application.routes.draw do
  get "search/index"
  get "search/results"
  get "users/show"
  get "home/index"

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :videos do
    collection do
      post :import_jaru_videos
    end

    member do
      post :remove_tag
    end

    resources :posts, only: [:new, :create]
  end

  resources :posts, only: [:edit, :update, :destroy]


  namespace :api do
    post '/video_watched', to: 'videos#watched'
  end

  get '/mypage', to: 'users#show', as: :mypage
  post '/users/regenerate_token', to: 'users#regenerate_token', as: :regenerate_token_users

  authenticated :user do
    root to: 'home#ranking', as: :authenticated_root
  end

  root "home#ranking"

  get 'search', to: 'search#index'  

  get 'search/results', to: 'search#results'

  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
