require "sass"
require "./util.cr"

module Sprockets
  class SASS
    property quiet  : Bool = true
    #property output : Array(String)
    private  property output : Array(String)

    def initialize(quiet : Bool = true)
      @quiet  = quiet
      @output = [] of String
    end

    def preprocess(filename : String) : Array(String)
      filenotfound(filename)
      read(filename)

      return compile()
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

        if line == ""
          next
        end

        #
        # process filename
        # either with or without extension
        #
        if md = line.match(/\/\/= require (.+)/)

          if md.size == 2

            filename = md[1].not_nil!
            #filename = strip_extension(org_filename)
            testfile(basedir,filename)

          end

        elsif md = line.match(/\*= require (.+)/)

          if md.size == 2

            #filename = strip_extension(md[1].not_nil!)
            filename = md[1].not_nil!
            testfile(basedir,filename)

          end

        elsif md = line.match(/@import '(.+)';/)

          if md.size == 2

            #filename = strip_extension(md[1].not_nil!)
            filename = md[1].not_nil!
            testfile(basedir,filename)

          end

        elsif md = line.match(/@import (.+);/)

          if md.size == 2

            #filename = remove_doublequotes(strip_extension(md[1].not_nil!))
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

              #filename = strip_extension(file)
              #testfile(dirname,filename)
              testfile(dirname,file)

            end
          end

        else
          #
          # skip inline comment starting at the beginning  (//)
          #
          if line =~ /^\/\//
            next
          end

          # skip comment lines like
          # /* .... */
          if line =~ /\/\*.+\*\//
            next
          end

          #
          # skip multi-comment lines
          # only for css
          #
          if line =~ /^\/\*/ && ext == ".css"
            next
          end

          if line =~ /\*\// && ext == ".css"
            next
          end

          # if line =~ /\/\*.\*\//
          #   next
          # end

          @output << line

        end
      end
    end

    #
    # test the presence of the stylesheet
    # with the following extension
    #
    # css
    # sass
    # scss
    #
    def testfile(basedir : String, org_filename : String)

      filename = strip_extension(org_filename)

      test_filename = basedir + "/" + filename + ".css"
      if File.exists?(test_filename)
        read(test_filename)
      end

      test_filename = basedir + "/" + filename + ".sass"
      if File.exists?(test_filename)
        read(test_filename)
      end

      test_filename = basedir + "/" + filename + ".scss"
      if File.exists?(test_filename)
        read(test_filename)
      end

      #
      # filename could be relative to directory
      # exmple
      # @import 'dir/file'
      #
      # Convention seems to be that 'file' is
      # stored as '_file'
      #

      #
      # test for directory (is there a '/')
      # if so replace '/' with '/_'
      #
      if filename =~ /\//
        filename = filename.gsub(/\//,"/_")

        test_filename = basedir + "/" + filename + ".css"
        if File.exists?(test_filename)
          read(test_filename)
        end

        test_filename = basedir + "/" + filename + ".sass"
        if File.exists?(test_filename)
          read(test_filename)
        end

        test_filename = basedir + "/" + filename + ".scss"
        if File.exists?(test_filename)
          read(test_filename)
        end
      end
    end

    def compile() : Array(String)
      output = [] of String

      #
      # nothing to compile
      #
      if @output.size == 0
        return output
      end

      # test output write_file("test_sass.txt",@output,0o755,true)
      s      = @output.join("\n")
      x      = Sass.compile(s) #,include_path: "includes")
      output = x.split("\n")
      return output
    end
  end
end