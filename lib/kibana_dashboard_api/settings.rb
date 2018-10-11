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

    def self.set_date_format(value)
      data = {:value => value}
      req  = HTTP::Repeater.post("/api/kibana/settings/dateFormat", :json => data)

      new(normalize_attribute(req.json))
    end

    def self.clear_date_format
      req = HTTP::Repeater.delete("/api/kibana/settings/dateFormat")

      new(normalize_attribute(req.json))
    end

    attr_reader :default_index, :date_format

    def initialize(attributes = {})
      @default_index = attributes[:defaultIndex]
      @date_format   = attributes[:dateFormat] || "MMMM Do YYYY, HH:mm:ss.SSS " # Kibana Default
    end
  end
  
end