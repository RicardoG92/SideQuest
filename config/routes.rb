Rails.application.routes.draw do
  get 'locations/index'
  devise_for :users
  root to: "pages#home"

  resources :side_quests do
    resources :reviews, only: %i[index new create]
  end
  resources :trips
  resources :locations, only: %i[new create]
  # all my owner sidequests
  get '/my-sidequest', to: 'sidequests#mysidequests', as: 'mysidequests'
  # list a dog(owner)
  get '/my-sidequest/:id', to: 'sidequests#show', as: 'mysidequest'
end
