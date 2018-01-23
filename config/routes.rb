Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :captioned_images, only: [:index, :create]
  root to: "captioned_images#index"
end
