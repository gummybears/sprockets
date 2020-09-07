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

    def read_plain(filename : String) : Array(String)
      File.read_lines(filename)
    end

    def remove_comments(input : Array(String) ) : Array(String)

      return input

      multiline = false
      lines = [] of String

      (0..input.size()-1).each do |i|
        line = trim(input[i])

        #
        # multiline comments ?
        #
        if line =~ /^\/\*/ && line !~ /\/\*.+\*\//
          multiline = true
        end

        if line =~ /^\*\//
          multiline = false
        end

        #
        # single line comments
        #
        if multiline == false
          if line =~ /\/\*.+\*\//

            x = line.gsub(/\/\*.+\*\//,"")
            if x.size > 0
              lines << x
            end

          elsif line =~ /^\/\/.+/

            x = line.gsub(/^\/\/.+/,"")
            if x.size > 0
              lines << x
            end

          elsif multiline == false

            if line.size > 0 && line !~ /^\*\//
              lines << line
            end
          end
        end
      end # each

      return lines
    end

  end
end
