Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'home#dashboard'
  get 'home/dashboard', as: "user_root"
end
