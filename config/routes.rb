Rails.application.routes.draw do
  root 'home#dashboard'
  get 'home/dashboard'
end
