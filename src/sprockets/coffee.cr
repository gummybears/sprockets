require "coffee-script"
require "./stream.cr"

module Sprockets
  class Coffee
    property quiet     : Bool = true
    property minifiied : Bool = false
    property is_js     : Bool = false
    property js        : Stream
    property coffee    : Stream

    def initialize(quiet : Bool = true, minified : Bool = false)
      @quiet    = quiet
      @minified = minified
      @output   = [] of String
      @js       = Stream.new
      @coffee   = Stream.new
    end

    def preprocess(filename : String) : Array(String)
      filenotfound(filename)
      read(filename)

      compile()
      return @js.to_a
    end

    def read(filename : String)

      if @quiet == false
        puts "sprockets : read filename #{filename}"
      end

      ext     = get_extension(filename)
      basedir = strip_file(filename)
      lines   = File.read_lines(filename)
      lines.each do |line|

        if line =~ /^@charset/
          next
        end

        #
        # process filename
        # either with or without extension
        #
        if md = line.match(/\/\/= require (.+)/)

          if md.size == 2

            filename = md[1].not_nil!
            testfile(basedir,filename)

          end

        elsif md = line.match(/\*= require (.+)/)

          if md.size == 2

            filename = md[1].not_nil!
            testfile(basedir,filename)

          end

        elsif md = line.match(/#= require (.+)/)

          if md.size == 2

            filename = md[1].not_nil!
            testfile(basedir,filename)

          end

        elsif md = line.match(/@import '(.+)';/)

          if md.size == 2

            filename = md[1].not_nil!
            testfile(basedir,filename)

          end

        elsif md = line.match(/@import (.+);/)

          if md.size == 2

            filename = remove_doublequotes(md[1].not_nil!)
            testfile(basedir,filename)

          end

        elsif md = line.match(/\/\/= require_tree (.+)/)

          if md.size == 2

            dirname = strip_extension(md[1].not_nil!)
            dirname = basedir + "/" + dirname
            if Dir.exists?(dirname) == false
              report_error("directory #{dirname} not found")
            end

            dir = Dir.new(dirname)
            dir.children.each do |file|
              testfile(dirname,file)
            end
          end

        else

          # skip backtick
          if line =~ /`/
            next
          end

          if line == ""
            line = " "
          end

          if @is_js
            @js.add(line)
          else
            @coffee.add(line)
          end
        end
      end
    end

    #
    # test the presence of the stylesheet
    # with the following extension
    #
    # js
    # coffee
    #
    def testfile(basedir : String, org_filename : String)

      filename = strip_extension(org_filename)

      test_filename = basedir + "/" + filename + EXTENSION_JS
      if File.exists?(test_filename)
        @is_js = true
        read(test_filename)
      end

      test_filename = basedir + "/" + filename + EXTENSION_COFFEE
      if File.exists?(test_filename)
        @is_js = false
        read(test_filename)
      end
    end

    def compile()

      #
      # nothing to compile
      #
      if @coffee.size == 0
        return
      end

      s    = @coffee.to_a.join("\n")
      temp = CoffeeScript.compile(s)
      if temp
        x = temp.not_nil!
        case x.class.to_s

          when "String"
            s = x.as(String)

            output = s.split("\n")
            @js.add(output)
          else
            # Crystal 0.34
        end # case
      end # if
    end
  end
end
