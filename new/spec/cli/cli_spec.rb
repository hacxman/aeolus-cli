require 'spec_helper'

module Aeolus
  module CLI
    describe "Aeolus::CLI" do
      context "load configuration" do
        before(:each) do
          restore_load_configuration
        end

        context "with (all) nonexisting files" do
          it do
            lambda {Aeolus::CLI.load_configuration(['th1sd03snotexi5t', 'n13th3r71s'])}
              .should raise_error(RuntimeError)
          end
        end

        context "with some nonexisting files" do
          subject do
            lambda do
              Aeolus::CLI.load_configuration(
                ['th1sd03snotexi5t',
                 File.join(File.dirname(__FILE__), '../fixtures/aeolus-cli')])
            end
          end

          it { should_not raise_error(RuntimeError) }
        end

        context "without :conductor: section" do
          it do
            lambda {Aeolus::CLI.load_configuration(['../fixtures/bad-aeolus-cli-0'])}
              .should raise_error(RuntimeError)
          end
        end

        context "with correct file contents" do
          subject do
            Aeolus::CLI.load_configuration(
               [File.join(File.dirname(__FILE__), '../fixtures/aeolus-cli')])
          end

          it { should include(:conductor)}
        end

      end

      describe "class Cli" do
        pending
      end
    end
  end
end
