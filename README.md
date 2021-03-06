# kibana_dashboard_api
This is a module for Kibana dashboard that provide an API to access the resource data.  
Currently supported resources
* [IndexPatterns](https://www.elastic.co/guide/en/kibana/current/index-patterns.html)
* [Settings](https://www.elastic.co/guide/en/kibana/current/advanced-options.html)
  * `dateFormat`

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'kibana_dashboard_api', :git => 'https://github.com/xyzkab/kibana_dashboard_api'
```

And then execute:
```bash
$ bundle install
```

## Documentation

### Basic Usage

Here's some simple examples to get you started:

```ruby
>> require 'kibana_dashboard_api'
=> true
>> KibanaDashboardApi.configure do |conf|
?>  conf.base_uri.host = "your-kibana-ipaddr-host"
>>  conf.base_uri.port = 5601
>>  conf.base_headers.content_type = "application/json"
>>  conf.base_headers[:kbn_xsrf] = "http://your-kibana-ipaddr-host:5601/"
>> end
=> #<HTTP::Configuration:0x0000557e561e0940 @base_uri=#<HTTP::Configuration::BaseURI:0x0000557e561e08c8 @host="your-kibana-ipaddr-host", @port=5601, @ssl=false>, @base_headers=#<HTTP::Configuration::BaseHeaders:0x0000557e561e0850 @headers=#<HTTP::Headers {"Content-Type"=>"application/json; charset=UTF-9", "Kbn-Xsrf"=>"http://your-kibana-ipaddr-host:5601/"}>>>
>> KibanaDashboardApi::Index.all
=> #<KibanaDashboardApi::Index::IndexCollection [#<KibanaDashboardApi::Index:0x0000557e56209f48 @key="posts", @doc_count=1>]>
>> KibanaDashboardApi::Index.find("posts")
=> #<KibanaDashboardApi::Index:0x0000557e562b2918 @key="posts", @doc_count=1>
>> pattern = KibanaDashboardApi::Index::Pattern.new(title: "posts", time_field_name: "updated_at", default_index: true)
=> #<KibanaDashboardApi::Index::Pattern:0x0000558ec6d45670 @id=nil, @type=nil, @title="posts", @time_field_name="updated_at", @default_index=true>
>> pattern.save
=> #<KibanaDashboardApi::Index::Pattern:0x0000558ec6d45670 @id="260982a0-cd2d-11e8-94bd-ebd66ce45135", @type="index-pattern", @title="posts*", @time_field_name="updated_at", @default_index=true>
>> KibanaDashboardApi::Index.patterns
=> [#<KibanaDashboardApi::Index::Pattern:0x0000557e5627cc00 @id="260982a0-cd2d-11e8-94bd-ebd66ce45135", @type="index-pattern", @title="posts", @time_field_name="updated_at", @default_index=true>]
>> pattern = KibanaDashboardApi::Index::Pattern.find("de05e720-cd1b-11e8-94bd-ebd66ce45135")
=> #<KibanaDashboardApi::Index::Pattern:0x0000557e55e6a568 @id="260982a0-cd2d-11e8-94bd-ebd66ce45135", @type="index-pattern", @title="posts", @time_field_name="updated_at", @default_index=true>
>> pattern.index
=> #<KibanaDashboardApi::Index:0x0000557e55e37230 @key="posts", @doc_count=1>
>> pattern.destroy
=> true
>> KibanaDashboardApi::Settings.all
=> #<KibanaDashboardApi::Settings:0x0000556ffff3e6b0 @default_index="0b49aef0-cd31-11e8-94bd-ebd66ce45135", @date_format="MMMM Do YYYY, HH:mm:ss.SSS ">
>> KibanaDashboardApi::Settings.set_date_format("Y/DD/MM - HH:mm:ss.SSS")
=> #<KibanaDashboardApi::Settings:0x0000556ffff5c5c0 @default_index="0b49aef0-cd31-11e8-94bd-ebd66ce45135", @date_format="Y/DD/MM - HH:mm:ss.SSS">
>> KibanaDashboardApi::Settings.clear_date_format
=> #<KibanaDashboardApi::Settings:0x0000556ffff81320 @default_index="0b49aef0-cd31-11e8-94bd-ebd66ce45135", @date_format="MMMM Do YYYY, HH:mm:ss.SSS ">
```
