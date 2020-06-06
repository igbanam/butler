module Butler
  class Logger
    private def initialize
      @logfile_path = "#{BUTLER_DIRECTORY}/service.log"
    end

    def self.instance
      @@instance ||= new
    end

    def log(message : String)
      write message
    end

    def log(instruction : Instruction::Instruction)
      write "[event] #{instruction}"
    end

    private def write(content : String)
      content += "\n"

      if File.exists? @logfile_path
        File.write @logfile_path, content, mode: "a"
      else
        File.write @logfile_path, content
      end
    end
  end
end
