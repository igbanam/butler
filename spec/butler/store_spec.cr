require "file_utils"
require "../spec_helper"

module Butler
  describe Store do
    before_all do
      FileUtils.rm_rf BUTLER_DIRECTORY
      Instruction::Initialize.new([] of String).execute
    end

    it "must be singleton" do
      a = Store.instance
      b = Store.instance

      a.should be(b)
    end

    describe "#save" do
      it "adds task to the task list" do
        store_size = Store.instance.tasks.size

        Store.instance.save Entity::Task.new(title: "test")
        new_store_size = Store.instance.tasks.size

        new_store_size.should eq(store_size + 1)
      end

      context "for duplicate tasks" do
        it "leaves the store unchanged" do
          Store.instance.save Entity::Task.new(title: "test")
          store_size = Store.instance.tasks.size

          Store.instance.save Entity::Task.new(title: "test")
          new_store_size = Store.instance.tasks.size

          new_store_size.should eq(store_size)
        end
      end
    end

    describe "#unique?" do
      it "is false for an exact match on title" do
        task = Entity::Task.new(title: "test")
        Store.instance.save task

        uniqueness = Store.instance.unique? task

        uniqueness.should be_false
      end
    end

    after_all do
      FileUtils.rm_rf BUTLER_DIRECTORY
    end
  end
end
