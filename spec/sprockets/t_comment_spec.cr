require "../spec_helper.cr"
require "../../src/sprockets/comment.cr"

describe "Comment" do

  describe "remove" do
    it "single line comment" do
      s = [] of String
      s << "1"
      s <<  "// xxx"
      s << "2"
      Comment.new(s).remove().join("|").should eq "1|2"
    end

    it "single line comment" do
      s = [] of String
      s << "1"
      s <<  "/* xxx*/"
      s << "2"
      Comment.new(s).remove().join("|").should eq "1|2"
    end

    it "single line comment starting with spaces" do
      s = [] of String
      s << "1"
      s <<  "   /* xxx */"
      s << "2"
      Comment.new(s).remove().join("|").should eq "1||2"
    end

    it "2 single line comment" do
      s = [] of String
      s << "1"
      s <<  "// xxx"
      s << "2"
      s << "//................... xxx ............................ //"
      Comment.new(s).remove().join("|").should eq "1|2"
    end

    it "multi line comment" do
      s = [] of String
      s << "1"
      s <<  "/* xxx"
      s << " * ...."
      s << " * ...."
      s << " yyyy */"
      s << "2"

      Comment.new(s).remove().join("|").should eq "1|2"
    end

    it "multi line comment" do
      s = [] of String

      s << "; /*"
      s << " * jQuery Easing v1.4.0 - http://gsgd.co.uk/sandbox/jquery/easing/"
      s << " * Open source under the BSD License."
      s << " * Copyright © 2008 George McGinley Smith"
      s << " * All rights reserved."
      s << " * https://raw.github.com/gdsmith/jquery-easing/master/LICENSE"
      s << " */ var x = 1;"
      Comment.new(s).remove().join("|").should eq ";|var x = 1;"
    end

    it "multi line comment" do
      s = [] of String
      s << "x = 1;"
      s << "/**"
      s << "* Create an instance of Axios"
      s << "*"
      s << "* @param {Object} defaultConfig The default config for the instance"
      s << "* @return {Axios} A new instance of Axios"
      s << "*/"
      s << "x = 2;"
      Comment.new(s).remove().join("|").should eq "x = 1;|x = 2;"
    end

    describe "some dumb comments (from axios.js)" do
      it "// abcd" do
        x = "// abcd"
        a = Comment.remove(x)
        a.should eq ""
      end

      it "defg // abcd" do
        x = "defg // abcd"
        a = Comment.remove(x)
        a.should eq "defg"
      end

      it "/* defg abcd */" do
        x = "/* defg abcd */"
        a = Comment.remove(x)
        a.should eq ""
      end

      it "abcd /******/ efgh // xyz" do
        x = "abcd /******/ efgh // xyz"
        a = Comment.remove(x)
        a.should eq "abcd   efgh"
      end

      it "/******/  // abcd" do
        x = "/******/  // abcd"
        a = Comment.remove(x)
        a.should eq ""
      end

      it "/******/  abcd" do
        x = "/******/ abcd"
        a = Comment.remove(x)
        a.should eq "abcd"
      end

      it "defg /* ..... */ abcd" do
        x = "defg /* .... */ abcd"
        a = Comment.remove(x)
        a.should eq "defg   abcd"
      end
    end
  end
end
