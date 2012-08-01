require 'yaml'
require 'rest-client'
require 'nokogiri'

module Aeolus
  module CLI
    class << self
      def load_configuration(locations = ['/etc/aeolus-cli', '~/.aeolus-cli'])
        locations = locations.map do |loc|
          File.expand_path(loc)
        end

        config = locations.select do |file|
          File.exists?(file)
        end.first

        if config == nil then
          raise "Can't find configuration file in any of the following locations #{locations}"
        end

        yml = YAML.load_file(config)
        
        if not yml.has_key?(:conductor) then
          raise "Configuration file #{config} doesn't contain :condutctor: section"
        end
        
        return yml
      end
    end

    class Cli
      def initialize
        config = Aeolus::CLI::load_configuration()
        config = config[:conductor]
        p load_api_entry(config)
      end

      def load_api_entry(config)
        begin
          RestClient.get(config[:url])
        rescue Errno::ECONNREFUSED => e
          e.message << " " << config[:url]
          raise
        end
      end
    end
  end
end

#cli = Aeolus::CLI::Cli.new
#Aeolus::CLI::load_configuration()
