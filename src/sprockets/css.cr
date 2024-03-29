require "sass"
require "./util.cr"
require "./resource.cr"

module Sprockets
  class CSS < Resource

    def preprocess(filename : String) : Array(String)
      filenotfound(filename)
      read(filename)
      return remove_comments(@output)
    end

    private def read(filename : String)

      basedir = strip_file(filename)
      lines   = File.read_lines(filename)
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

            filename = remove_doublequotes(strip_extension(md[1].not_nil!))
            testfile(basedir,filename)

          end

        elsif md = line.match(/\/\/= require_tree (.+)/)

          if md.size == 2

            dirname = strip_extension(md[1].not_nil!)
            dirname = basedir + "/" + dirname
            if Dir.exists?(dirname) == false
              report_error("directory #{dirname} not found")
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
    private def testfile(basedir : String, filename : String)

      full_filename = basedir + "/" + filename + EXTENSION_CSS
      if File.exists?(full_filename)
        read(full_filename)
      end

      full_filename = basedir + "/" + filename + EXTENSION_SASS
      if File.exists?(full_filename)
        read(full_filename)
      end

      full_filename = basedir + "/" + filename + EXTENSION_SCSS
      if File.exists?(full_filename)
        read(full_filename)
      end
    end
  end
end
