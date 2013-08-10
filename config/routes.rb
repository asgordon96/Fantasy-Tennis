FantasyTennis::Application.routes.draw do
  
  get "sessions/signin"
  post "sessions/signout"
  post "sessions/create"
  match '/' => 'home#index', :via => :get
  resources :users, :only => [:new, :create, :update, :destroy, :show]
  
  resources :leagues, :only => [:new, :create, :index, :show, :destroy] do
    resources :teams, :only => [:show, :new, :create, :update, :destroy]
    resource :draft, :only => :show
  end

end
