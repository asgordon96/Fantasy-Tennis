FantasyTennis::Application.routes.draw do
  
  get "sessions/signin"
  get "sessions/signout"
  post "sessions/create"
  match '/' => 'home#index', :via => :get
  resources :users, :only => [:new, :create, :update, :destroy]

end
