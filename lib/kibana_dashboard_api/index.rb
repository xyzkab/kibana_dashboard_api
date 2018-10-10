require 'kibana_dashboard_api/index/bucket'
require 'kibana_dashboard_api/index/pattern'

module KibanaDashboardApi
  
  class Index

    def self.all
      data_index   = {:size => 0, :aggs => {:indices => {:terms => {:field => "_index", :size => 120} }}}
      req_index    = HTTP::Repeater.post("/elasticsearch/*/_search", json: data_index)

      IndexCollection.new(*req_index.json[:aggregations][:indices][:buckets])
    end

    def self.find(name)
      all.find do |bucket|
        bucket.key == name
      end
    end

    def patterns
      data_pattern = {:type => "index-pattern", :fields => "title", :per_page => 10000}
      req_pattern  = HTTP::Repeater.get("/api/saved_objects", params: data_pattern)

      req_pattern.json[:saved_objects].map do |pattern|
        Pattern.new(pattern) if pattern[:type] == "index-pattern"
      end.select { |attribute| attribute.title.match(/#{@key}.*/) }
    end

    attr_reader :key, :doc_count

    def initialize(attributes = {})
      @key = attributes[:key]
      @doc_count = attributes[:doc_count]
    end

    class IndexCollection

      include Enumerable

      def initialize(*buckets)
        @buckets = buckets.map do |bucket|
          Index.new(bucket)
        end
      end

      def [](index)
        to_a[index]
      end

      def last
        @buckets.last
      end

      def to_a
        @buckets.select { |bucket| !bucket.key.match(/.kibana|.monitoring-(kibana|es)/) }
      end

      def inspect
        "#<#{self.class} #{to_a.inspect}>"
      end

      def include_system_index
        @buckets
      end

      def each(*args, &block)
        @buckets.each(*args, &block)
      end
    end

  end
end