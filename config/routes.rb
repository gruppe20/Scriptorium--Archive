Archive::Engine.routes.draw do
  get "home/index"
  root :to => "home#index"
  
  match 'ajax/:action(/:data)' => "ajax#index"
end
