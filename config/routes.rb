Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find', to: 'search#single_result'
        get '/find_all', to: 'search#multi_result'
        get '/:id/merchants', to: 'merchants#show'
      end
      
      namespace :merchants do
        get '/find', to: 'search#single_result'
        get '/find_all', to: 'search#multi_result'
        get '/most_revenue', to: 'biz_intel#rank_by_revenue'
        get '/:id/items', to: 'items#index'
        get '/:id/revenue', to: 'biz_intel#merchant_revenue'
      end

      resources :items, only: [:index, :show, :create, :update, :destroy]

      resources :merchants, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
