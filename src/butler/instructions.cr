module Butler
  BUTLER_DIRECTORY = ".butler"
  BUTLER_DATA = "#{BUTLER_DIRECTORY}/store.json"
  # .butler
  #   +-> service.log
  #   +-> tasks.json

  module Instruction
    abstract class Instruction
      abstract def execute
      abstract def to_s

      def reject!(concern)
        raise concern
      end

      def display(collection : Array)
        collection.each { |item| puts "#{item}" }
        :qa
      end
    end

    class Initialize < Instruction
      def initialize(details : Array(String))
        error_message = "Init syntax is  ---> ./butler init"
        reject!(concern: MalformedInstruction.new(error_message)) unless details.empty?
      end

      def execute
        create_butler_directory
        initialize_store
        Butler::Logger.instance.log "Initialized Butler in #{__DIR__}"
      rescue File::AlreadyExistsError
        Butler::Logger.instance.log "Reinitialized Butler in #{__DIR__}"
        STDERR.puts "Your butler is already initialized."
      end

      def to_s
        "butler init"
      end

      private def create_butler_directory
        Dir.mkdir BUTLER_DIRECTORY
      end

      private def initialize_store
        Store.instance
      end
    end

    class CreateTask < Instruction
      @details : String

      def initialize(details : Array(String))
        error_message = "Tasks syntax is  ---> ./butler tasks add [TITLE]"
        reject!(concern: MalformedInstruction.new(error_message)) if details.empty?
        @details = details.join
        Butler::Logger.instance.log self
      end

      def execute
        task = Entity::Task.new(title: @details)
        Store.instance.save task
        Store.instance.persist!
      end

      def to_s
        "butler task create #{@details}"
      end
    end

    class ListTasks < Instruction
      def initialize(details : Array(String))
        error_message = "List syntax is  ---> ./butler task list"
        reject!(concern: MalformedInstruction.new(error_message)) unless details.empty?
      end

      def execute
        tasks = read_tasks

        puts "+==== TASK LIST ====+"
        display tasks
      end

      def to_s
        "bundler tasks list"
      end

      private def read_tasks
        Store.instance.tasks
      end
    end
  end
end
