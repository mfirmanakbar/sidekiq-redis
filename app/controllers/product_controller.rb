class ProductController < ApplicationController
  def index; end

  def report
    # generate_report()
  end

  private

  def generate_report
    sleep 30
  end
end
