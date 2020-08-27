require "../spec_helper.cr"
require "../../src/sprockets/util.cr"

describe "Util" do
  it "trim" do
    s = "  message   "
    trim(s).should eq "message"
  end
end
