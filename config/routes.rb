Rails.application.routes.draw do
  get 'mypages/show'
  get 'shops/index'
  devise_for :users

  # ログイン済みは shops#index へ
  authenticated :user do
    root "shops#index", as: :authenticated_root
  end

  # 未ログインは home#index へ
  unauthenticated do
    root "home#index"
  end

  resources :shops
  resource :mypage, only: [:show]
  resources :users, only: [:edit, :update]
end
