module Butler
  class Logger
    private def initialize
      @logfile_path = "#{BUTLER_DIRECTORY}/service.log"
    end

    def self.instance
      @@instance ||= new
    end

    def log(message : String) : Nil
      File.open(@logfile_path, "a") do |log_file|
        log_file.puts message
      end
    end
  end
end
