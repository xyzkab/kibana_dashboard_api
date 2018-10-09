require 'http'
require 'http/repeater'
require 'kibana_dashboard_api/index'

module KibanaDashboardApi
  
  extend HTTP::Configuration::Mixin

  def self.after_configure
    # Copying `self` configuration to HTTP::Repeater
    HTTP::Repeater.configure do |conf|
      conf.base_uri.host = @configuration.base_uri.host
      conf.base_uri.port = @configuration.base_uri.port
      @configuration.base_headers.each do |key, val|
        conf.base_headers[key] = val
      end
    end
  end
end
