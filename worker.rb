require 'sidekiq'
require 'sidekiq-cron'
require_relative './app/services/gen_feedback_xml_service.rb'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
  config.on(:startup) do
    schedule_file = 'config/schedule.yml'

    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end

class GenerateFeedbackWorker
  include Sidekiq::Worker

  def perform
    GenFeedbackXmlService.generate_feedback_xml
  end
end
