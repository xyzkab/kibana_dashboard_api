module KibanaDashboardApi
  
  class Index

    class Pattern

      def self.all
        data_pattern = {:type => "index-pattern", :fields => "title", :per_page => 10000}
        req_pattern  = HTTP::Repeater.get("/api/saved_objects", params: data_pattern)

        req_pattern.json[:saved_objects].map do |pattern|
          new(pattern) if pattern[:type] == "index-pattern"
        end
      end

      attr_reader :id, :title, :type, :time_field_name

      def initialize(attributes)
        @id    = attributes[:id]
        @type  = attributes[:type]
        @title = attributes[:attributes] ? attributes[:attributes][:title] : attributes[:title]
        @time_field_name = attributes[:time_field_name]
        @default_index = attributes[:default_index] || false
      end

      def save
        data   = {:attributes => {:title => "#{@title}*", :timeFieldName => @time_field_name} }
        req    = HTTP::Repeater.post("/api/saved_objects/index-pattern", :json => data)
        @id    = req.json[:id]
        @type  = req.json[:type]
        @title = req.json[:attributes][:title]
        @time_field_name = req.json[:time_field_name]
        set_default_index if @default_index
        self
      end

      def destroy
        req = HTTP::Repeater.delete("/api/saved_objects/index-pattern/#{@id}")

        if req.status.code != 200
          raise HTTP::RequestError.new("id `#{@id}` not found")
        else
          true
        end
      end

      def set_default_index
        req = HTTP::Repeater.post("/api/kibana/settings/defaultIndex", :json => {:value => @id})
        req.json
      end
      
    end

  end
end