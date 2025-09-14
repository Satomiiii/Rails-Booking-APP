# config/routes.rb
Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { registrations: 'registrations' }

  # 施設
  resources :rooms do
    collection do
      get :search   # /rooms/search → rooms#search
    end

    # 予約（部屋配下：confirm の room付きパスヘルパを作る）
    resources :reservations, only: [:new, :create] do
      collection do
        post :confirm  # confirm_room_reservations_path(@room)
      end
    end
  end

  # 予約（一覧・詳細だけ必要ならトップレベルで）
  resources :reservations, only: [:index, :show]

  # ユーザー関連
  resources :users, only: [:show] do
    member do
      get   :edit_account
      patch :update_account
      get   :account
      get   :profile
      patch :update_profile
      # プロフィール編集への別名ルートを使っている場合
      get   :edit_profile, to: 'users#edit_profile', as: :edit_profile
    end
  end

  # トップの「おすすめエリア」用の独自ルーティング
  get 'tokyo_rooms',   to: 'rooms#tokyo_index',   as: 'tokyo_rooms'
  get 'osaka_rooms',   to: 'rooms#osaka_index',   as: 'osaka_rooms'
  get 'kyoto_rooms',   to: 'rooms#kyoto_index',   as: 'kyoto_rooms'
  get 'sapporo_rooms', to: 'rooms#sapporo_index', as: 'sapporo_rooms'

  # トップページ
  root 'pages#home'
end
