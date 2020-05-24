require "../spec_helper"

describe Butler::Dispatcher do
  it "rejects unsupported commands" do
    expect_raises(Butler::UnknownInstruction) do
      Butler::Dispatcher.dispatch!(["igbanam"])
    end
  end
end
