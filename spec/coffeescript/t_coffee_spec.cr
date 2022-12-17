require "../spec_helper.cr"
require "../../src/sprockets/coffee.cr"

describe "Coffee compiler" do

  it "test1.coffee" do
    filename = "spec/coffeescript/test1.coffee"
    s = Sprockets::Coffee.new()
    output = s.preprocess(filename)
    #output.should eq ["(function() {", "acoffeefunction(function() {", "var withsomedata;", "withsomedata = 12;", "});", "}).call(this);"]
    output.should eq ["(function() {", "  acoffeefunction(function() {", "    var withsomedata;", "    withsomedata = 12;", "  });", "}).call(this);"]
  end
end
