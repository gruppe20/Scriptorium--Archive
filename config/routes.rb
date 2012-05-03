Archive::Engine.routes.draw do
  get "home/index"
  root :to => "home#index"
end
