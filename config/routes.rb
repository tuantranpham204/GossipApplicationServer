Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  # Ensure confirmation links hit our overridden controller
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Defines the root path route ("/")
      # root "posts#index"

      devise_for :users,
                 path_names: {
                   sign_in: "sign_in",
                   sign_out: "sign_out",
                   registration: "sign_up"
                 },
                 controllers: {
                   sessions: "users/sessions",
                   registrations: "users/registrations",
                   confirmations: "users/confirmations"
                   #  omniauth_callbacks: "users/omniauth_callbacks"
                 },
                 defaults: { format: :json }
      resources :users, only: [] do
        collection do
          patch "me", to: "user#update_me"
        end
      end
      resources :profiles, only: [] do
        collection do
          get "search", to: "profile#search"

          get "host/:user_id", to: "profile#get_by_host"
          get "guest/:user_id", to: "profile#get_by_guest"

          patch "avatar/:user_id", to: "profile#update_avatar"
          get "avatar/:user_id", to: "profile#get_avatar"

          patch "update/:user_id", to: "profile#update"
        end
      end
    end
  end
end
