# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # organization関連==================================================
  resources :organizations do
    scope module: :organizations do
      resources :folders
    end
    member do
      scope module: :organizations do
        resource :unsubscribe, only: %i[show update], as: :organizations_unsubscribe
        resource :admission, only: %i[show update destroy], as: :organizations_admission
      end
    end
  end
  # =================================================================

  # system_admin関連=========================================================
  devise_for :system_admins, skip: %i[registrations], controllers: {
    sessions:  'system_admins/sessions',
    passwords: 'system_admins/passwords'
  }

  resources :system_admins, only: %i[show edit update] do
  end
  # =================================================================

  # user関連=======================================================
  devise_for :users, skip: %i[registrations], controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    confirmations: 'users/confirmations',
    registrations: 'users/registrations'
  }

  resources :users do
    member do
      scope module: :users do
        resource :unsubscribe, only: %i[show update], as: :users_unsubscribe
      end
    end
  end

  post 'users_create', to: 'users#create'
  # =================================================================

  # viewer関連==========================================================
  devise_for :viewers, controllers: {
    sessions:      'viewers/sessions',
    passwords:     'viewers/passwords',
    confirmations: 'viewers/confirmations',
    registrations: 'viewers/registrations'
  }

  resources :viewers do
    member do
      scope module: :viewers do
        resource :unsubscribe, only: %i[show update], as: :viewers_unsubscribe
      end
    end
  end
  # =================================================================

  # video関連=========================================================
  resources :videos do
    resources :comments, only: %i[create update destroy] do
      resources :replies, only: %i[create update destroy]
    end
  end

  # =================================================================

  # 共通==============================================================
  # 利用規約
  get 'use' => 'use#index'
  # トップページ
  root 'use#top'
  # =================================================================
end
