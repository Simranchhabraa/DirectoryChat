Rails.application.routes.draw do
  namespace :bx_block_chat do
    resources :messages
    resources :conversations do
      collection do 
        post :information
        post :userchat
      end
    end
    # get 'users/:id', to: 'conversations#information', as: :user_information
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
