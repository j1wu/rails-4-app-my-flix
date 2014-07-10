Myflix::Application.routes.draw do
  resources :videos do
    
  end

  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'
end