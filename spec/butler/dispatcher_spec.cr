require "file_utils"
require "../spec_helper"

module Butler
  describe Dispatcher do
    before_all do
      FileUtils.rm_rf BUTLER_DIRECTORY
      Instruction::Initialize.new([] of String).execute
    end

    it "rejects unsupported instructions" do
      expect_raises(UnknownInstruction) do
        Dispatcher.dispatch!(["igbanam"])
      end
    end

    it "routes 'task add' to the AddTask instruction" do
      intent = "task add Begin!".split
      instruction = Dispatcher.new(intent.first, intent[1..-1]).route
      instruction.is_a?(Instruction::CreateTask).should be_true
    end

    it "routes 'task List' to the ListTasks instruction" do
      intent = "task list".split
      instruction = Dispatcher.new(intent.first, intent[1..-1]).route
      instruction.is_a?(Instruction::ListTasks).should be_true
    end

    after_all do
      FileUtils.rm_rf BUTLER_DIRECTORY
    end
  end
end
