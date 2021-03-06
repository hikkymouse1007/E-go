require_relative 'boot'

require 'rails/all'
require "google/cloud/translate"

Bundler.require(*Rails.groups)

module EGo
  class Application < Rails::Application
    config.load_defaults 5.2

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exists?(env_file)
        YAML.safe_load(File.open(env_file), [], [], true).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end
  end
end
