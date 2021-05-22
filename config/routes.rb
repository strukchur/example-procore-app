Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get '/authenticate', to: 'authentication#index'
  get '/oauth_callback', to: 'authentication#oauth_callback'
  get '/oauth_success', to: 'authentication#oauth_success', as: :oauth_success
end
