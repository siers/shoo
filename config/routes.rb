Shoo::Application.routes.draw do
  root :to => 'games#index'
  resources :games, :only => [:show, :index]
end
