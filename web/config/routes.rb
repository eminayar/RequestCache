Rails.application.routes.draw do
  get 'welcome/index'

  resources :videos

  get 'videos/page/:timestamp', to:'videos#index'

  root 'videos#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
