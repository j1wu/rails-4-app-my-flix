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

  root to: "pages#front"
  get 'home', to: 'videos#index'
  
  get 'register', to: 'users#new'
  get 'forgot_password', to: 'users#forgot_password'
  post 'reset_password', to: 'users#reset_password'
  get 'confirm_password_reset', to: 'users#confirm_password_reset'
  get 'update_password/:token', to: 'users#update_password', as: 'update_password'
  post 'save_password/:user_id', to: 'users#save_password', as: 'save_password'

  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'people', to: 'relationships#index'
  post 'follow/:user_id', to: 'relationships#create', as: 'follow'
  
  get 'my_queue', to: 'queue_items#index'
  post 'add_queue/:id', to: 'queue_items#create', as: 'add_queue'
  post 'update_queue', to: 'queue_items#update_queue'

  get 'ui(/:action)', controller: 'ui'
end
