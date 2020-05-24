require "option_parser"
require "./butler/*"

# Keeps track of projects
#
# butler init
#   - initialize a Butler project
# butler tasks
#   - show all tasks in the project
# butler task show ID
#   - detail the task with ID
# butler "start-task | task start" ID
#   - mark a task as started
# butler "complete-task | tash complete" ID
#   - mark a task as complete
module Butler
  VERSION = "0.1.0"

  OptionParser.parse do |parser|
    parser.banner = "Usage: butler <command> [<args>]\n\nSupported Commands are:
    #{Dispatcher::SUPPORTED_INSTRUCTIONS}"

    parser.on "-v", "Show Version" do
      puts "Butler, version #{VERSION}"
    end

    parser.on "-h", "Help" do
      puts parser
    end

    parser.unknown_args do |input|
      raise UnknownInstruction.new if input.empty?
      Dispatcher.dispatch!(input)
    rescue e : UnknownInstruction | MalformedInstruction
      STDERR.puts e.message
      STDERR.puts e.cause
      STDERR.puts parser
    end
  end

  # Butler::Service.run(command, args)
end
