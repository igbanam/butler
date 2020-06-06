require "json"

module Butler
  module Entity
    class Task
      include JSON::Serializable

      @[JSON::Field(key: "title")]
      property title : String

      @[JSON::Field(key: "completed_at", emit_null: true)]
      property completed_at : (Time)?

      def initialize(@title)
        @completed_at = nil
      end

      def initialize(@title, @completed_at); end
    end
  end
end
