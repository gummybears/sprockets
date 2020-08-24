require "../spec_helper.cr"
require "../../src/sprockets/js.cr"

describe "JS" do
  describe "require" do
    it "app1.js" do
      filename = "spec/javascript/app1.js"
      js = Sprockets::JS.new
      output = js.preprocess(filename)
      output.join("\n").should eq "console.log(\"hello world\");"
    end

    it "app2.js" do
      filename = "spec/javascript/app2.js"
      js = Sprockets::JS.new
      output = js.preprocess(filename)
      output.join("\n").should eq "console.log(\"hello world\");"
    end

    it "app3.js" do
      filename = "spec/javascript/app3.js"
      js = Sprockets::JS.new
      output = js.preprocess(filename)
      output.join("\n").should eq "console.log(\"hello world\");"
    end

    it "app4.js" do
      filename = "spec/javascript/app4.js"
      js = Sprockets::JS.new
      output = js.preprocess(filename)
      output.join("\n").should eq "console.log(\"hello world\");"
    end

    it "app5.js" do
      filename = "spec/javascript/app5.js"
      js = Sprockets::JS.new
      output = js.preprocess(filename)
      output.join("\n").should eq "console.log(\"hello world\");"
    end

    it "app2.coffee" do
      filename = "spec/javascript/app2.coffee"
      js = Sprockets::JS.new
      output = js.preprocess(filename)
      output.join("\n").should eq "console.log(\"hello world\");"
    end
  end
end
