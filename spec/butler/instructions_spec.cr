require "file_utils"
require "../spec_helper"

module Butler
  module Instruction
    describe Initialize do
      it "with details is a malformed instruction" do
        expect_raises(MalformedInstruction) do
          Initialize.new(["any"])
        end
      end

      it "create a .butler directory" do
        no_details = [] of String

        Initialize.new(no_details).execute

        expectation = File.directory?(".butler")
        expectation.should be_true
      end

      context "when a butler already exists" do
        it "does not re-initialize project" do
          no_details = [] of String
          Initialize.new(no_details).execute
          fresh = File.size(".butler/service.log")
          File.open(".butler/service.log", "a") do |file|
            file.puts "Meaningless test data"
          end
          working = File.size(".butler/service.log")

          Initialize.new(no_details).execute

          expected = File.size(".butler/service.log")
          expected.should_not eq(fresh)
        end
      end
    end

    Spec.after_each do
      FileUtils.rm_r(".butler") if File.directory?(".butler")
    end
  end
end
