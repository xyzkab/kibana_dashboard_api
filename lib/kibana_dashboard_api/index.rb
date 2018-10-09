require 'kibana_dashboard_api/index/bucket'
require 'kibana_dashboard_api/index/pattern'

module KibanaDashboardApi
  
  class Index

    def self.all
      data_index   = {:size => 0, :aggs => {:indices => {:terms => {:field => "_index", :size => 120} }}}
      data_pattern = {:type => "index-pattern", :fields => "title", :per_page => 10000}
      req_index    = HTTP::Repeater.post("/elasticsearch/*/_search", json: data_index)
      req_pattern  = HTTP::Repeater.get("/api/saved_objects", params: data_pattern)
      new(req_index.json[:aggregations][:indices][:buckets],req_pattern.json[:saved_objects])
    end

    def self.find(name)
      all.buckets.find do |bucket|
        bucket.key == name
      end
    end

    attr_reader :buckets, :patterns

    def initialize(buckets, patterns)
      @buckets = buckets.map do |bucket|
        item = Bucket.new(bucket)
        item unless item.key.match(/.kibana|.monitoring-(kibana|es)/)
      end.compact
      @patterns = patterns.map do |pattern|
        item = Pattern.new(pattern)
        item if item.type == 'index-pattern'
      end.compact
    end

  end
end