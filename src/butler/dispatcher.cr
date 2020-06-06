module Butler
  class Dispatcher
    SUPPORTED_INSTRUCTIONS = [
      "init",
      "task"
    ]

    COMMAND_MAP = {
      "init" => Butler::Instruction::Initialize,
      "task-add" => Butler::Instruction::CreateTask
    }

    def self.dispatch!(intent : Array(String))
      return reject! ["[nothing]"] if intent.empty? || intent.first.blank?
      return reject! intent unless SUPPORTED_INSTRUCTIONS.includes?(intent.first)

      instruction = intent.first
      details = intent[1..-1]

      new(instruction, details).dispatch
    end

    private def self.reject!(intent : Array(String))
      message = "I do not understand #{intent}"
      raise UnknownInstruction.new(message: message)
    end

    def initialize(@instruction : String, @details : Array(String))
    end

    def dispatch
      route.execute
    end

    def route : Instruction::Instruction
      if @instruction == "task" # this is an umbrella instruction
        @instruction = "#{@instruction}-#{@details[0]}"
        @details = @details[1..-1]
      end
      COMMAND_MAP[@instruction].new(@details)
    end
  end

  # Thoughts around this is one of intent and events. I've been stuck on
  # thinking about how to represent it for too long, I think it's best I log the
  # thoughts and move on. The idea is this.
  #
  # When a user calls the butler with some input, the input is "registered" as
  # an intent. This intent then logs an event with the butler service. Then
  # butler workers can work through the intents, carrying out the specific
  # tasks to satisfy this intent.
  #
  # Here be three classes
  #   - Intent        what is to be done
  #   - Event         an occurence in the Butler's mind
  #   - Task          action performed by a butler to satisfy an intent
  #
  # With this logged, it's become a to-do for the future. I will focus on using
  # the less robust command model to get this done for now, pending when I can
  # find the zen to think this through.
end
