Rails.application.routes.draw do
  # to view sinatra web ui
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'product#index'

  # product controller for example page
  get '/product' => 'product#index', as: 'product_index'
  get '/product/report' => 'product#report', as: 'product_report'
end
