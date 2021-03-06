Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions' }

  root to: 'tasks#index'
  get '/privacy', to: 'pages#privacy'
  resources :tasks, only: [:create]
end
