Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :update, :destroy]
      
      get 'merchants/:id/items', to: 'merchants#items'

      namespace :merchants do
        get '/most_revenue', to: 'biz_intel#rank_by_revenue'
        get '/:id/revenue', to: 'biz_intel#merchant_revenue'
      end
    end
  end
end
