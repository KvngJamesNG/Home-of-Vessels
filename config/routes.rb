Rails.application.routes.draw do
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  
  # Public pages
  get "about", to: "pages#about"
  get "gallery", to: "pages#gallery"
  get "contact", to: "pages#contact"
  
  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "logout", to: "sessions#destroy" # GET fallback for logout
  
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  
  get "profile", to: "users#profile"
  patch "profile", to: "users#update_profile"
  
  # Password reset routes
  get "forgot-password", to: "sessions#forgot_password"
  post "send-reset-instructions", to: "sessions#send_reset_instructions"
  get "reset-password", to: "sessions#reset_password"
  patch "update-password", to: "sessions#update_password"
  
  # Protected routes (require login)
  get "courses", to: "pages#courses"
  post "enroll", to: "pages#enroll"
  
  # Form submissions
  post "newsletter_subscribe", to: "pages#newsletter_subscribe"
  post "contact_form", to: "pages#contact_form"
end
