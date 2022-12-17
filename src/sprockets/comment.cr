
class Comment
  property input : Array(String)

  def initialize(input : Array(String))
    @input = input
  end

  def self.remove(line : String) : String


    # /* ..... */ ...
    if md = line.match( /^\/\/*.+\*\/(.+)/ )
      match_1 = md[1]
      line = trim(match_1)
    end

    # abcd // ......
    if md = line.match( /(.+)\/\// )
      match_1 = md[1]
      line = trim(match_1)
    end

    # abcd /* .......... */ def
    if md = line.match( /(.+)\/\/*.+\*\/(.+)/ )
      match_1 = md[1]
      match_2 = md[2]
      line = trim(match_1 + " " + match_2)
    end

    # /* ..... */
    if line =~ /^\/\/*.+\*\//
      return ""
    end

    # // abcd
    if line =~ /^\/\/.+/
      return ""
    end

    return line
  end

  def multiline_comment(line : String) : Bool

    #
    # /* ...... but no */
    #
    if line =~ /^\/\*/ && testline !~ /\/\*.+\*\//
      return true
    end

    return false
  end


  def remove() : Array(String)

    multiline = false
    lines = [] of String

    @input.each do |line|

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
      # new code, 05-07-2022
      #
      # Note: we could have a very long single line
      # the regex will take forever
      # decided to skip these lines
      #
      if line.size > 512
        lines << trim(line)
        next
      end

      # line is the start of a multiline comment
      # possibly with some text in front of it
      # like
      #
      # 'some text'  /* .........
      #
      # need to grap the text 'some text'
      #

      if testline =~ /^.+\/\*/ && testline !~ /\/\*.+\*\//

        multiline = true

        x = testline.gsub(/\/\*/,"")
        lines << trim(x)
      end

      #
      # multi lines comments start with a
      # '/*' and ends with a '*/'
      #
      # The idea is to remove everyting in between /* and */
      #

      #
      # multiline comment ends when we encounter a line
      # with '........ */'
      # Note : dots can be any character but not the combination '*/'
      # as '*/*/'
      #
      #

      #
      # Example of possible comment end line
      #
      #  .... */ some text
      #
      # need to grap the text 'some text'
      #
      if md = line.match( /(.+)\*\/(.+)/ )
        match_1 = md[1]
        match_2 = md[2]
        lines << trim(match_2)
        multiline = false
        next
      end

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
