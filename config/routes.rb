Myflix::Application.routes.draw do
  resources :videos do
    
  end

  resources :categories, only: [:show]

  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'
end