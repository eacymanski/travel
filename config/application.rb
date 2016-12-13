require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Travel
  class Application < Rails::Application
    Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }
    config.active_record.raise_in_transactional_callbacks = true
  end
end
