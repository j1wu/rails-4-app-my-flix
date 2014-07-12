Myflix::Application.routes.draw do
  resources :videos do
    collection do
      post 'search', to: 'videos#search'
    end 
  end

  resources :categories, only: [:show]

  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'
end