class ReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false # dont repeat the worker when got error

  def perform(start_date, end_date)
    puts "Firman-Keju: Sidekiq worker generating a report from #{start_date} to #{end_date}"
  end
end
