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

    def remove_comments(input : Array(String) ) : Array(String)

      delimiter = "__xyz__"
      s = input.join(delimiter)

      #
      # /* ... */ on a single line
      #
      x = s.gsub(/\/\*.+\*\//,"")

      #
      # /* .. lines */ non greedy
      #
      x = x.gsub(/\/\*.+?\*\//m,"")

      #
      # // single line comment
      #
      x = x.gsub(/\/\/.+/,"")

      output = [] of String
      lines = x.split(delimiter)
      lines.each do |l|

        #
        # empty line
        #
        if l.size > 0
          output << l
        end

      end

      return output
    end

  end
end
