Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'product#index'

  # to view sinatra web ui
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # product controller for example page
  get '/product' => 'product#index' # , as: product_index
  get '/product/report' => 'product#report' # , as: product_report
end
