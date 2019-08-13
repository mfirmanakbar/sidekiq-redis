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
