Rails.application.routes.draw do
  # 認証 (Devise, Googleログイン)
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # 動画 (Video) とコメント (Post)
  resources :videos do
    collection do
      post :import_jaru_videos
    end

    member do
      delete :remove_tag
      get :remove_tag
      post :watched 
    end

    resources :posts, only: [:new, :create]
  end

  resources :posts, only: [:edit, :update, :destroy]

  resources :search, only: [:index]

  # API エンドポイント
  namespace :api do
    post 'videos/watched', to: 'videos#watched'
  end

  # ヘッダー
  
  # マイページ
  get '/mypage', to: 'users#show', as: :mypage 
  
  # トークン再生成アクション
  post '/users/regenerate_token', to: 'users#regenerate_token', as: :regenerate_token_users

  # ルートページの設定
  root "home#ranking" # ログイン状態にかかわらず、ここがトップページになる

  # その他 (Railsのデフォルト)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end