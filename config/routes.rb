Rails.application.routes.draw do
  
  Rails.application.routes.draw do
  # 施設
  resources :rooms do
    collection do
      get :search      # /rooms/search → rooms#search
    end
  end

  # トップの「おすすめエリア」用
  get 'tokyo_rooms',   to: 'rooms#tokyo_index',   as: 'tokyo_rooms'
  get 'osaka_rooms',   to: 'rooms#osaka_index',   as: 'osaka_rooms'
  get 'kyoto_rooms',   to: 'rooms#kyoto_index',   as: 'kyoto_rooms'
  get 'sapporo_rooms', to: 'rooms#sapporo_index', as: 'sapporo_rooms'

  # トップページ
  root 'pages#home'
end

end
