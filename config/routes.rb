FantasyTennis::Application.routes.draw do
  
  get "sessions/signin"
  post "sessions/signout"
  post "sessions/create"
  match '/' => 'home#index', :via => :get
  resources :users, :only => [:new, :create, :update, :destroy, :show]
  
  resources :leagues, :only => [:new, :create, :index, :show, :destroy] do
    resources :teams, :only => [:show, :new, :create, :update, :destroy] do
      member do
        post 'drop'
      end
    end
    
    resource :draft, :only => :show do
      collection do
        post 'buyplayer'
        get 'myteam'
        get 'available'
        get 'nominator'
      end
    end
  end

end
