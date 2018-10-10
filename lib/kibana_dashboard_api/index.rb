require 'kibana_dashboard_api/index/bucket'
require 'kibana_dashboard_api/index/pattern'

module KibanaDashboardApi
  
  class Index

    def self.all
      data_index   = {:size => 0, :aggs => {:indices => {:terms => {:field => "_index", :size => 120} }}}
      req_index    = HTTP::Repeater.post("/elasticsearch/*/_search", json: data_index)

      IndexCollection.new(*req_index.json[:aggregations][:indices][:buckets])
    end

    def self.find(key)
      all.find do |bucket|
        bucket.key == key
      end
    end

    def self.patterns
      Pattern.all
    end

    attr_reader :key, :doc_count

    def initialize(attributes = {})
      @key = attributes[:key]
      @doc_count = attributes[:doc_count]
    end

    def patterns
      self.patterns.select { |attribute| attribute.title.match(/#{@key}.*/) }
    end

    class IndexCollection

      extend Forwardable
      include Enumerable

      def initialize(*buckets)
        @buckets = buckets.map do |bucket|
          Index.new(bucket)
        end
      end

      def [](index)
        to_a[index]
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

      def_delegator :@buckets, :last
    end

  end
end