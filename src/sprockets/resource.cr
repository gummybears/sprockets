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

    # old code def remove_comments(input : Array(String) ) : Array(String)
    # old code
    # old code   multiline = false
    # old code   lines = [] of String
    # old code
    # old code   (0..input.size()-1).each do |i|
    # old code     line = trim(input[i])
    # old code
    # old code     #
    # old code     # multiline comments ?
    # old code     #
    # old code     if line =~ /^\/\*/ && line !~ /\/\*.+\*\//
    # old code       multiline = true
    # old code     end
    # old code
    # old code     if line =~ /^\*\//
    # old code       multiline = false
    # old code     end
    # old code
    # old code     #
    # old code     # single line comments
    # old code     #
    # old code     if multiline == false
    # old code       if line =~ /\/\*.+\*\//
    # old code
    # old code         x = line.gsub(/\/\*.+\*\//,"")
    # old code         if x.size > 0
    # old code           lines << x
    # old code         end
    # old code
    # old code       elsif line =~ /^\/\/.+/
    # old code
    # old code         x = line.gsub(/^\/\/.+/,"")
    # old code         if x.size > 0
    # old code           lines << x
    # old code         end
    # old code
    # old code       elsif multiline == false
    # old code
    # old code         if line.size > 0 && line !~ /^\*\//
    # old code           lines << line
    # old code         end
    # old code       end
    # old code     end
    # old code   end # each
    # old code
    # old code   return lines
    # old code end

    def remove_comments(input : Array(String) ) : Array(String)

      multiline = false
      lines = [] of String

      # old code (0..input.size()-1).each do |i|
      input.each do |line|
        # old code line     = input[i]
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

            # old code if line.size > 0 && testline !~ /\*\/$/
            # old code   lines << trim(line)
            # old code end

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
