require 'http'
require 'http/repeater'
require 'kibana_dashboard_api/index'
require 'kibana_dashboard_api/settings'

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

  def self.available?
    begin
      return false if !@configuration
      return true if HTTP::Repeater.head("/")
    rescue
      false
    end
  end
end
