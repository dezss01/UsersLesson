# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  namespace :api do
    resources :tags, only: :index
  end
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    root 'main#index'

    resources :users, only: %i[new create edit update]
    resources :youtube_lessons, only: %i[show index]
    resource :session, only: %i[new create destroy]

    resources :questions, concerns: :commentable do
      resources :answers, except: %i[new show]
    end

    resources :answers, except: %i[new show], concerns: :commentable

    # пространство имен для роутов админ
    namespace :admin do
      resources :users, only: %i[index create]
      resources :youtube_lessons, only: %i[index create]
    end
  end
end
