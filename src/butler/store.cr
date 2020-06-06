require "json"
require "./datatypes"

module Butler
  class Store
    @tasks = [] of Entity::Task

    def self.instance
      @@instance ||= new
    end

    def persist!
      puts "Tasks are #{@tasks}"
      File.write @store_path, @tasks.to_json
    end

    def save(task : Entity::Task)
      @tasks << task if unique?(task)
    end

    def unique?(task : Entity::Task)
      !@tasks.map { |task| task.title }.includes?(task.title)
    end

    protected def tasks
      @tasks
    end

    private def initialize
      @store_path = BUTLER_DATA
      File.exists?(BUTLER_DATA) ? load : create
    end

    private def create
      raise ConfusedButler.new unless @tasks.empty?
      persist!
    end

    private def load
      tasks_json = File.read @store_path
      @tasks = Array(Entity::Task).from_json(tasks_json)
    end
  end
end
