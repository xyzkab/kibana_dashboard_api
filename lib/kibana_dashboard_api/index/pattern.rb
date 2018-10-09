module KibanaDashboardApi
  
  class Index

    class Pattern

      attr_reader :id, :title, :type, :time_field_name

      def initialize(attributes)
        @id    = attributes[:id]
        @type  = attributes[:type]
        @title = attributes[:attributes][:title]
        @time_field_name = attributes[:time_field_name]
      end
      
    end

  end
end