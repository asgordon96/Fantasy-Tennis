FantasyTennis::Application.routes.draw do
  
  resources :users, :only => [:new, :create, :update, :destroy]

end
