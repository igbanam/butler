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
    end

    Spec.after_each do
      FileUtils.rm_r(".butler") if File.directory?(".butler")
    end
  end
end
