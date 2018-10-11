module KibanaDashboardApi

  class Settings
    
    def self.all
      req = HTTP::Repeater.get("/api/kibana/settings")
      
      new(normalize_attribute(req.json))
    end

    def self.normalize_attribute(attributes)
      attributes[:settings].map do |key, value|
        attributes[:settings][key] = attributes[:settings][key][:userValue]
      end

      return attributes[:settings]
    end

    attr_reader :default_index, :date_format

    def initialize(attributes = {})
      @default_index = attributes[:defaultIndex]
      @date_format   = attributes[:dateFormat]
    end
  end
  
end