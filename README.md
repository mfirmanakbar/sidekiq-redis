# Simple Sidekiq

## What is Sidekiq ?

![](https://i.ibb.co/dWcgYqN/image.png)
Simple, efficient background processing for Ruby.

What is that mean?

> **Example**: Heroku Server by Default give us 30 second for 1 request, more than it, we will got error like `timeout` for the our UI, so we need run it by background service, So in rails we can use Sidekiq for background service, Sinatra for Sidekiq-UI, and Redis will automatically storing sidekiq data.

## Requirement
- Rails
- Redis
- Sidekiq

## Step to Do
- Create simple project
  ```
  $ rails new sidekiq-redis
  ```

- Install Redis in your PC, in this case i'm using mac so i just intall redis using `brew` 
  ```
  $ brew install redis
  ```

- Run the Redis
    ```
    $ redis-server ## for run
    ```

- Open Redis CLI (the second command is for Check all list if any key stored in Redis)
    ```
    $ redis-cli
    $ KEYS * 
    $ exit
    ```

- add 2 gems. first sidekiq it self and 
    ```
    gem 'sidekiq'
    gem 'sinatra', github: 'sinatra/sinatra'
    ```

- Install bundle inside your project
  ```
  $ bundle install
  ```

- Update routes.rb
    ```ruby
    Rails.application.routes.draw do
        # to view sinatra web ui
        require 'sidekiq/web'
        mount Sidekiq::Web => '/sidekiq'

        root to: 'product#index'

        # product controller for example page
        get '/product' => 'product#index', as: 'product_index'
        get '/product/report' => 'product#report', as: 'product_report'
    end
    ```

- Create new Folder `wokrers` and new controller inside that, `workers/report_worker.rb`
    ```ruby
    class ReportWorker
        include Sidekiq::Worker
        sidekiq_options retry: false # dont repeat the worker when got error

        def perform(start_date, end_date)
            puts "Firman-Keju: Sidekiq worker generating a report from #{start_date} to #{end_date}"
        end
    end
    ```


- Create product_controller.rb
    ```ruby
    class ProductController < ApplicationController
        def index
            # puts something
        end

        def report
            # generate_report
            ReportWorker.perform_async('01-08-2019', '10-08-2019')
            render plain: 'Firman-Keju: Request to generate a report added to the Queue'
        end

        private

        def generate_report
            sleep 5
        end
    end
    ```

- Create new Folder `product` inside `views` and create the html page
  - index.html.erb
    ```html
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <title>Document</title>
        </head>
        <body>
            <h1>Create a Product Report</h1>
            <a href="<%= product_report_url %>"> 
                Generate Product Report 
            </a>
        </body>
    </html>
    ```

  - report.html.erb 
    ```html
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <title>Document</title>
        </head>
        <body>
            <h1>This is Product Report</h1>
        </body>
    </html>
    ```

- Then run the Rails
  ```
  $ rails s -p 3003
  ```

- Open http://localhost:3003/sidekiq/ should be like this
  ![](https://i.ibb.co/s5cyjsW/image.png)
  
- Then the root
  ![](https://i.ibb.co/S034zT7/image.png)

- Click `Generate Product Report`
  ![](https://i.ibb.co/54CMYLb/image.png)

- Then the enqueued should be 1
  ![](https://i.ibb.co/S7GrnzV/image.png)

- The step above just for queueing. We need to run sidekiq (inside the project folder) on terminal to exec that
  ```
  $ sidekiq -c 1
  ```

  `i've no idea yet why it comes with 1 thread`

- Then open http://localhost:3003/sidekiq/ again and you will see `0 Enqueued, 1 Processed `

- Next Project we will learn to create a sheduler for this 