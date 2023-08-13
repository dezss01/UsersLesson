# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'main#index'

  resources :users, only: %i[new create edit update]
  resources :youtube_lessons, only: %i[show index]
  resource :session, only: %i[new create destroy]
  resources :questions do
    resources :answers
  end

  # пространство имен для роутов админ
  namespace :admin do
    resources :users, only: %i[index create]
    resources :youtube_lessons, only: %i[index create]
  end
end
