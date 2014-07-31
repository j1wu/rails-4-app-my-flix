Myflix::Application.routes.draw do
  resources :videos do
    collection do
      post 'search', to: 'videos#search'
    end 
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create, :destroy]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy]

  root to: "pages#front"
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'people', to: 'relationships#index'
  
  get 'my_queue', to: 'queue_items#index'
  post 'add_queue/:id', to: 'queue_items#create', as: 'add_queue'
  post 'update_queue', to: 'queue_items#update_queue'

  get 'ui(/:action)', controller: 'ui'
end
