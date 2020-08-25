require "sass"
require "./util.cr"

module Sprockets
  class CSS
    private property output : Array(String)

    def initialize
      @output = [] of String
    end

    def preprocess(filename : String)
      filenotfound(filename)
      read(filename)
      return @output
    end

    def read(filename : String)

      basedir = strip_file(filename)
      lines  = File.read_lines(filename)
      lines.each do |line|

        #
        # process filename
        # either with or without extension
        #
        if md = line.match(/\/\/= require (.+)/)

          if md.size == 2

            filename = strip_extension(md[1].not_nil!)
            testfile(basedir,filename)

          end

        elsif md = line.match(/\*= require (.+)/)

          if md.size == 2

            filename = strip_extension(md[1].not_nil!)
            testfile(basedir,filename)

          end

        elsif md = line.match(/@import '(.+)';/)

          if md.size == 2

            filename = strip_extension(md[1].not_nil!)
            testfile(basedir,filename)

          end

        elsif md = line.match(/@import (.+);/)

          if md.size == 2

            filename = strip_extension(md[1].not_nil!)
            testfile(basedir,filename)

          end

        elsif md = line.match(/\/\/= require_tree (.+)/)

          if md.size == 2

            dirname = strip_extension(md[1].not_nil!)
            dirname = basedir + "/" + dirname
            if Dir.exists?(dirname) == false
              puts "sprockets : directory #{dirname} not found"
              exit(0)
            end

            #
            # read all the files in the directory
            #
            dir = Dir.new(dirname)
            dir.children.each do |file|

              filename = strip_extension(file)
              testfile(dirname,filename)

            end
          end

        else

          #
          # skip lines which have comment markers
          # like  '/*' ||  '*/'
          #
          if line =~ /\/\*/ || line =~ /\*\// || line =~ /\/\//
            next
          end

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
    def testfile(basedir : String, filename : String)

      full_filename = basedir + "/" + filename + ".css"
      if File.exists?(full_filename)
        read(full_filename)
      end

      full_filename = basedir + "/" + filename + ".sass"
      if File.exists?(full_filename)
        read(full_filename)
      end

      full_filename = basedir + "/" + filename + ".scss"
      if File.exists?(full_filename)
        read(full_filename)
      end
    end
  end
end