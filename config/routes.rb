Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  
  root to: 'static_pages#home'
  
  match '/signup',   to: 'users#new', via: :all
  match '/signin',   to: 'sessions#new', via: :all
  match '/signout',  to: 'sessions#destroy', via: :delete
  
  match '/help',     to: 'static_pages#help', via: :all
  match '/about',    to: 'static_pages#about', via: :all
  match '/contact',  to: 'static_pages#contact', via: :all
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
