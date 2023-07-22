Rails.application.routes.draw do
  get :admin, to: 'admin#index'

  controller :sessions do
    get :login, action: :new
    post :login, action: :create
    delete :logout, action: :destroy
    get :logout, action: :destroy
  end

  resources :users
  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: :store_index, via: :all
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
