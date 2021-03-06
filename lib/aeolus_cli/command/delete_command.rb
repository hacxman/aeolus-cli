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

module Aeolus
  module CLI
    class DeleteCommand < BaseCommand
      def initialize(opts={}, logger=nil)
        super(opts, logger)
      end

      def provider_image
        begin
          pi = ProviderImage.new({:id => @options[:providerimage]})
          if response = pi.destroy
            puts "Provider Image: " + @options[:providerimage] + " Deleted Successfully"
            puts ""
            print_provider_content(response.body)
            exit(0)
          end
        rescue => e
          handle_exception(e)
        end
      end

      def target_image
        begin
          ti = TargetImage.new({:id => @options[:targetimage]})
          if response = ti.destroy
            puts "Target Image: " + @options[:targetimage] + " Deleted Successfully"
            puts ""
            print_provider_content(response.body)
            exit(0)
          end
        rescue => e
          handle_exception(e)
        end
      end

      def build
        begin
          b = Build.new({:id => @options[:build]})
          if response = b.destroy
            puts "Build: " + @options[:build] + " Deleted Successfully"
            puts ""
            print_provider_content(response.body)
            exit(0)
          end
        rescue => e
          handle_exception(e)
        end
      end

      def image
        begin
          i = Image.new({:id => @options[:image]})
          if response = i.destroy
            puts "Image: " + @options[:image] + " Deleted Successfully"
            puts ""
            print_provider_content(response.body)
            exit(0)
          end
        rescue => e
          handle_exception(e)
        end
      end

      private
      def print_provider_content(content_xml)
        h = Hash.from_xml(content_xml)
        if provider_content = h[h.keys.first]["content"]["provider_content"]
        content = provider_content.instance_of?(Array) ? provider_content : [provider_content]
          if content.size > 0
            widths = calculate_widths(content)
            puts "N.B. The following provider content must be manually removed"
            puts ""

            # Print Headers
            printf("%-#{widths[:provider] + 5}s", "Provider")
            printf("%-#{widths[:id] + 5}s", "ID")
            puts ""

            # Print Column Lines
            printf("%-#{widths[:provider] + 5}s", "-" * widths[:provider])
            printf("%-#{widths[:id] + 5}s", "-" * widths[:id])
            puts ""

            # Print Content
            content.each do |pc|
              printf("%-#{widths[:provider] + 5}s", pc["provider"])
              printf("%-#{widths[:id] + 5}s", pc["target_identifier"])
              puts ""
            end
          end
        end
      end

      def calculate_widths(content)
        widths = {:provider => 8, :id => 2}

        content.to_a.each do |pc|
          if pc["provider"].length > widths[:provider]
            widths[:provider] = pc["provider"].length
          end
          if pc["target_identifier"].length > widths[:id]
            widths[:id] = pc["target_identifier"].length
          end
        end
        widths
      end

    end
  end
end
