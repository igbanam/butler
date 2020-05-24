module Butler
  BUTLER_DIRECTORY = ".butler"
  # .butler
  #   +-> service.log
  #   +-> tasks.json

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
        create_butler_directory
        Butler::Logger.instance.log "Initialized Butler in #{__DIR__}"
      rescue File::AlreadyExistsError
        STDERR.puts "Your butler is already initialized."
      end

      private def create_butler_directory
        Dir.mkdir BUTLER_DIRECTORY
      end
    end
  end
end
