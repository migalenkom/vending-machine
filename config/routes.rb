Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users do
        put :deposit, on: :collection
        put :reset, on: :collection
        get :profile, on: :collection
      end

      resources :products do
        post :buy, on: :member
      end
    end
  end
end
