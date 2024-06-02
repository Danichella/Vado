# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :messages, only: [:index, :create, :destroy] do
        get :build_response, on: :member
        get :voice_response, on: :member
      end
      resources :notifications, only: [:index, :destroy] do
        patch :readed, on: :member
      end

      get 'settings', to: 'settings#show'
      patch 'settings', to: 'settings#update'
      put 'settings', to: 'settings#update'
      get 'accounts/current', to: 'accounts#current'
    end
  end
end
