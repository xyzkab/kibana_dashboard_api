module KibanaDashboardApi
  
  class Index

    class Bucket

      attr_reader :key, :doc_count

      def initialize(attributes)
        @key = attributes[:key]
        @doc_count = attributes[:doc_count]
      end
      
    end

  end
end