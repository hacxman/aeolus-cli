#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))

require 'cli'

module Helpers
  def restore_load_configuration
    Aeolus::CLI.class_eval do
      class << self
        alias :load_configuration :old_load_configuration
      end
    end
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.before(:all) do
    Aeolus::CLI.class_eval do
      class << self
        alias :old_load_configuration :load_configuration
      end

      def self.load_configuration
        YAML::load(File.open(File.join(File.dirname(__FILE__), "/fixtures/aeolus-cli")))
      end
    end
  end
end
