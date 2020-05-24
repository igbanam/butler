module Butler
  module Instruction
    abstract class Instruction
      abstract def execute

      def reject!(reason)
        raise reason.new
      end
    end

    class Initialize < Instruction
      def initialize(details : Array(String))
        reject!(reason: MalformedInstruction) unless details.empty?
      end

      def execute
        # Initialize the project
      end
    end
  end
end
