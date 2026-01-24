Rails.application.routes.draw do
  resources :users, only: [ :new, :create ]
  resource :session
  resources :passwords, param: :token
  resources :notes do
    resources :todos, except: [ :index ]
  end
  resources :todos do
    patch :update_positions, on: :collection
    resources :notes, except: [ :index ]
  end

  # Static pages
  get "about", to: "pages#about", as: :about
  get "contact", to: "pages#contact", as: :contact
  get "login", to: "sessions#new", as: :login
  get "signup", to: "users#new", as: :signup

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
