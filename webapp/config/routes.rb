Rails.application.routes.draw do
  root "home#index"
  get '/forecast', to: 'forecast#index'
  resource :forecast, only: [:index]
end
