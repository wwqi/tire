require 'test_helper'

module Tire

  class ConfigurationTest < Test::Unit::TestCase

    def teardown
      Tire::Configuration.reset
      ENV['ELASTICSEARCH_URL'] = nil
    end

    context "Configuration" do
      setup do
        Configuration.instance_variable_set(:@url,    nil)
        Configuration.instance_variable_set(:@client, nil)
      end

      teardown do
        Configuration.reset
      end

      should "return default URL" do
        assert_equal 'http://localhost:9200', Configuration.url
      end

      should "allow setting and retrieving the URL" do
        assert_nothing_raised { Configuration.url 'http://example.com' }
        assert_equal 'http://example.com', Configuration.url
      end
      
      should "set the url from an environment variable, if present" do
        ENV['ELASTICSEARCH_URL'] = 'http://es.example.com'
        assert_equal 'http://es.example.com', Configuration.url
      end

      should "strip trailing slash from the URL" do
        assert_nothing_raised { Configuration.url 'http://slash.com:9200/' }
        assert_equal 'http://slash.com:9200', Configuration.url
      end

      should "return default global_index_name of nil" do
        assert_nil Configuration.global_index_name
      end

      should "allow setting and retrieving the global_index_name" do
        assert_nothing_raised { Configuration.global_index_name 'unique_key_or_name' }
        assert_equal 'unique_key_or_name', Configuration.global_index_name 
      end
      
      should "strip trailing slash from global_index_name" do
        assert_nothing_raised { Configuration.global_index_name 'unique_key_or_name/' }
        assert_equal 'unique_key_or_name', Configuration.global_index_name
      end
      
      should "return default index_url of nil" do
        assert_nil Configuration.index_url
      end
      
      should "allow setting and retrieving of the index_url" do
        assert_nothing_raised { Configuration.index_url 'http://es.example.com/chunky_bacon' }
        assert_equal 'http://es.example.com/chunky_bacon', Configuration.index_url
      end
      
      should "strip trailing slash from index_url" do
        assert_nothing_raised { Configuration.index_url 'http://es.example.com/unique_key_or_name/' }
        assert_equal 'http://es.example.com/unique_key_or_name', Configuration.index_url
      end
      
      should "set the URL and global_index_name from index_url" do
        assert_nothing_raised { Configuration.index_url 'http://es.example.com/unique_key_or_name' }
        assert_equal 'http://es.example.com', Configuration.url
        assert_equal 'unique_key_or_name', Configuration.global_index_name
      end

      should "return default client" do
        assert_equal HTTP::Client::RestClient, Configuration.client
      end

      should "return nil as logger by default" do
        assert_nil Configuration.logger
      end

      should "return set and return logger" do
        Configuration.logger STDERR
        assert_not_nil Configuration.logger
        assert_instance_of Tire::Logger, Configuration.logger
      end

      should "set pretty option to true by default" do
        assert_not_nil Configuration.pretty
        assert Configuration.pretty, "Should be true, but is: #{Configuration.pretty.inspect}"
      end

      should "set the pretty option to false" do
        Configuration.pretty(false)
        assert ! Configuration.pretty, "Should be falsy, but is: #{Configuration.pretty.inspect}"
      end

      should "allow to reset the configuration for specific property" do
        Configuration.url 'http://example.com'
        assert_equal      'http://example.com', Configuration.url
        Configuration.reset :url
        assert_equal      'http://localhost:9200', Configuration.url
      end

      should "allow to reset the configuration for all properties" do
        Configuration.url     'http://example.com'
        Configuration.wrapper Hash
        assert_equal          'http://example.com', Configuration.url
        Configuration.reset
        assert_equal          'http://localhost:9200', Configuration.url
        assert_equal          HTTP::Client::RestClient, Configuration.client
      end
    end

  end

end
