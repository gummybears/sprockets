class Line
  property nr     : Int32
  property spaces : Int32
  property text   : String

  def initialize(text : String, spaces : Int32, nr : Int32)
    @text   = text
    @spaces = spaces
    @nr     = nr
  end

  def to_s() : String
    return @text
  end
end

class Stream
  property indent : Int32 = 0
  property nr     : Int32 = 1
  property buffer : Array(Line)
  property type   : String

  def initialize
    @type   = ""
    @nr     = 1
    @buffer = [] of Line
  end

  def initialize(type : String)
    @type   = type
    @nr     = 1
    @buffer = [] of Line
  end

  # returns the size of the buffer
  def size() : Int32
    return @buffer.size()
  end

  # clear buffer
  def clear()
    @nr = 1
    @buffer = [] of Line
  end

  #
  # add line
  #
  def add(line : Line)
    buffer << line
    @nr = @nr + 1
  end

  #
  # add stream
  #
  def add(s : Stream)
    s.buffer.each do |line|
      add(line)
    end
  end

  #
  # add array of Line to buffer
  #
  def add(lines : Array(Line))
    lines.each do |line|
      if line.text != ""
        @nr  = @nr + 1
        @buffer << line
      end
    end
  end

  #
  # add string to buffer
  #
  def add(s : String, spaces : Int32 = 0)
    if s != ""
      line = Line.new(s,spaces,@nr)
      @nr  = @nr + 1
      @buffer << line
    end
  end

  #
  # add empty line to buffer
  #
  def add_empty(spaces : Int32 = 0)
    line = Line.new("",spaces,@nr)
    @nr  = @nr + 1
    @buffer << line
  end

  #
  # add array to buffer
  #
  def add(arr : Array(String), spaces : Int32 = 0)
    arr.each do |s|

      if s != ""
        spaces = @indent
        line = Line.new(s,spaces,@nr)
        @nr  = @nr + 1

        @buffer << line
      end

    end
  end

  #
  # returns the string representation of the buffer
  #
  def to_a() : Array(String)
    s = [] of String

    @buffer.each do |x|
      s << x.text
    end

    return s
  end

  #
  # save stream to file
  #
  def write(filename : String)
    lines = to_a()

    begin
      file  = File.new(filename,"wb")
      lines.each do |line|
        file.puts line
      end
      file.close
    rescue e
      puts "cannot create file '#{filename}'"
      exit
    end
  end

  def to_s(separator : String = "")
    s = [] of String
    lines = contents()
    lines.each do |line|
      s << line.to_s
    end

    return s.join(separator)
  end
end
