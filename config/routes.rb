Rails.application.routes.draw do
  devise_for :users
  resources :products do
    collection do
      get :search
    end
    member do
      post :add
    end
  end

 # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "products#index"
end
