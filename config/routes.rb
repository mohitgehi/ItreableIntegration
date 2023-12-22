Rails.application.routes.draw do
  get 'events/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "events#index"
  post 'events/event/:event_name', to: 'events#handle_event'
  # post 'event_a', to: 'events#event_a', as: :event_a
  # post 'event_b', to: 'events#event_b', as: :event_b
  post 'send_email', to: 'events#send_email', as: :send_email
end
