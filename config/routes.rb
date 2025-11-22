Rails.application.routes.draw do
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

  resources :shops, only: [:index]
end
