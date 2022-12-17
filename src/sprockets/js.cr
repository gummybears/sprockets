require "sass"
require "./util.cr"
require "./resource.cr"

module Sprockets
  class JS < Resource

    def preprocess(filename : String) : Array(String)
      filenotfound(filename)
      read(filename)
      # 06-07-2022 disabled return remove_comments(@output)
      return @output
    end

    private def read(filename : String)

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

        elsif md = line.match(/#= require (.+)/)

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

          # disabled 06-07-2022 #
          # disabled 06-07-2022 # skip lines which have comment markers
          # disabled 06-07-2022 # like  '/*' ||  '*/'
          # disabled 06-07-2022 #
          # disabled 06-07-2022 if line =~ /\/\*/ || line =~ /\*\// || line =~ /\/\//
          # disabled 06-07-2022   next
          # disabled 06-07-2022 end

          @output << line

        end
      end
    end

    #
    # test the presence of either javascript or coffeescript
    #
    private def testfile(basedir : String, filename : String)

      full_filename1 = basedir + "/" + filename + EXTENSION_JS
      flag1 = false
      flag2 = false

      if File.exists?(full_filename1)
        read(full_filename1)
        flag1 = true
      end

      full_filename2 = basedir + "/" + filename + EXTENSION_COFFEE
      if File.exists?(full_filename2)
        read(full_filename2)
        flag2 = true
      end

      if flag1 == false && flag2 == false
        report_error("file '#{filename}(.js|coffee)' not found")
      end
    end
  end
end
