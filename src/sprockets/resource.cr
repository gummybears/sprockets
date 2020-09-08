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

      multiline = false
      lines = [] of String

      input.each do |line|
        testline = trim(line)
        if testline.size == 0
          next
        end

        #
        # multiline comments ?
        #
        if testline =~ /^\/\*/ && testline !~ /\/\*.+\*\//
          multiline = true
        end

        #
        # multiline comment ends when we encounter a line
        # with '........ */'
        # Note : dots can be any character but not the combination '*/'
        # as '*/*/'
        #
        #
        if testline =~ /\*\/$/
          multiline = false
        end

        #
        # single line comments
        #
        if multiline == false
          #
          # single line comment '/* ...... */'
          #
          if testline =~ /\/\*.+\*\//

            x = line.gsub(/\/\*.+\*\//,"")
            if x.size > 0
              lines << trim(x)
            end

          #
          # single line comment '// ......'
          #
          elsif testline =~ /^\/\/.+/

            x = line.gsub(/\/\/.+/,"")
            x = trim(x)
            if x.size > 0
              lines << trim(x)
            end

          elsif multiline == false

            x = trim(line)
            if x.size > 0 && testline !~ /\*\/$/
              lines << x
            end

          end
        end
      end # each

      return lines
    end
  end
end
