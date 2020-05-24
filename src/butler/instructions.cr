module Butler
  BUTLER_DIRECTORY = ".butler"

  module Instruction
    abstract class Instruction
      abstract def execute

      def reject!(concern)
        raise concern
      end
    end

    class Initialize < Instruction
      def initialize(details : Array(String))
        error_message = "Init syntax is  ---> ./butler init"
        reject!(concern: MalformedInstruction.new(error_message)) unless details.empty?
      end

      def execute
        Dir.mkdir BUTLER_DIRECTORY
      end
    end
  end
end
