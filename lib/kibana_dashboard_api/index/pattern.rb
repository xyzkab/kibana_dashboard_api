module KibanaDashboardApi
  
  class Index

    class Pattern

      def self.all
        data_pattern = {:type => "index-pattern", :fields => ["title","timeFieldName"], :per_page => 10000}
        req_pattern  = HTTP::Repeater.get("/api/saved_objects", params: data_pattern)

        req_pattern.json[:saved_objects].map do |pattern|
          new(pattern) if pattern[:type] == "index-pattern"
        end
      end

      def self.find(id)
        all.find do |pattern|
          pattern.id == id
        end
      end

      def self.find_by_title(title)
        all.find do |pattern|
          pattern.title == "#{title}*"
        end
      end

      attr_reader :id, :title, :type, :time_field_name

      def initialize(attributes)
        @id    = attributes[:id]
        @type  = attributes[:type]
        @title = attributes[:attributes] ? attributes[:attributes][:title] : attributes[:title]
        @time_field_name = attributes[:attributes] ? attributes[:attributes][:timeFieldName] : attributes[:time_field_name]
        @default_index = attributes[:default_index] || false
      end

      def save
        data   = {:attributes => {:title => "#{@title}*", :timeFieldName => @time_field_name} }
        pattern = Pattern.find_by_title(@title)

        if pattern # return current pattern if exist
          @id = pattern.id
          @type = pattern.type
          @time_field_name = pattern.time_field_name
          return self
        else
          req    = HTTP::Repeater.post("/api/saved_objects/index-pattern", :json => data)
          @id    = req.json[:id]
          @type  = req.json[:type]
          @title = req.json[:attributes][:title]
          @time_field_name = @time_field_name
          set_default_index if @default_index
          return self
        end
      end

      def destroy
        req = HTTP::Repeater.delete("/api/saved_objects/index-pattern/#{@id}")

        if req.status.code != 200
          raise HTTP::RequestError.new("id `#{@id}` not found")
        else
          true
        end
      end

      def update_attributes(attributes)
        data = {:attributes => attributes}

        if fieldFormatMap = attributes[:fieldFormatMap]
          data[:attributes][:fieldFormatMap] = fieldFormatMap.to_json
        end

        req  = HTTP::Repeater.put("/api/saved_objects/index-pattern/#{@id}", :json => data)
        req.json
      end

      def set_default_index
        req = HTTP::Repeater.post("/api/kibana/settings/defaultIndex", :json => {:value => @id})
        req.json
      end

      def index
        title = @title[-1] == "*" ? @title[0..-2] : @title
        @index ||= Index.find(title)
      end
      
    end

  end
end