require "json"
require "./util.cr"

module Sprockets

  class Resource
    property quiet     : Bool = true
    property minified  : Bool = false
    private property output : Array(String)

    def initialize(quiet : Bool = true, minified : Bool = false)
      @quiet    = quiet
      @minified = minified
      @output   = [] of String
    end

    def preprocess(filename : String) : Array(String)
      filenotfound(filename)
      read(filename)
      return @output
    end

  end
end
