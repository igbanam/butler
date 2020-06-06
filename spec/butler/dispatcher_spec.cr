require "../spec_helper"

module Butler
  describe Dispatcher do
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
  end
end
