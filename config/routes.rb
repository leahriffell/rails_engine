Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :update, :destroy]

      get 'merchants/:id/revenue', to: 'merchants/biz_intel#merchant_revenue'
    end
  end
end
