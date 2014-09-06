Myflix::Application.routes.draw do
  resources :videos do
    collection do
      post 'search', to: 'videos#search'
    end 
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
  resources :users, only: [:create, :show, :update]
  resources :sessions, only: [:create, :destroy]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy, :create]

  namespace :admin do
    resources :videos, only: [:create]
    get 'add_video', to: 'videos#new', as: 'add_video'
  end

  root to: "pages#front"
  get 'home', to: 'videos#index'
  
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#register_with_invitation', as: 'register_with_invitation'

  resources :forgot_passwords, only: [:create]
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :reset_passwords, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:create]
  get 'invitation', to: 'invitations#new'

  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'people', to: 'relationships#index'
  post 'follow/:user_id', to: 'relationships#create', as: 'follow'
  
  get 'my_queue', to: 'queue_items#index'
  post 'add_queue/:id', to: 'queue_items#create', as: 'add_queue'
  post 'update_queue', to: 'queue_items#update_queue'

  get 'ui(/:action)', controller: 'ui'
end
