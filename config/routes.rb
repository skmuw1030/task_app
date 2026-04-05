Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in", as: :guest_sign_in
  end

  root "home#index"

  resources :tasks do
    collection do
      get :created
    end

    resources :sub_tasks, shallow: true, only: [ :new, :create, :edit, :update, :destroy ]
  end
end
