require "digest/md5"
require "compress/gzip"
require "json"

# checks directory exists
def check_dir(name : String)
  if Dir.exists?(name) == false
    report_error(sprintf("directory '%s' does not exist",name))
  end
end

# checks file exists
def check_file(name : String)
  if File.exists?(name) == false
    report_error(sprintf("file '%s' does not exist",name))
  end
end

#
# returns the path without the filename
#
def strip_file(filename : String) : String
  return File.dirname(filename)
end

#
# returns the file extension
#
def get_extension(filename : String) : String
  File.extname(filename)
end

#
# returns the filename without its extension
#
def strip_extension(filename : String) : String
  ext = File.extname(filename)

  filename = filename.gsub("#{ext}") {""}
  return filename
end

# returns the file without the path
def strip_directory(filename : String) : String
  return File.basename(filename)
end

def filenotfound(filename : String)
  if File.exists?(filename) == false
    report_error("sprockets : file #{filename} not found")
  end
end

def report_error(s : String)
  puts "sprockets : #{s}"
  exit(-1)
end

def report_info(s : String)
  puts "sprockets : #{s}"
end

def is_directory?(dir : String) : Bool
  return File.directory?(dir)
end

#
# returns a digested name given filename
#
def digest_filename(filename : String, version : String = "") : {String, String}

  ext      = get_extension(filename)
  digest   = compute_md5hash(filename)

  #
  # by adding the version we can force assets to expire
  #
  if version != ""
    digest = digest + "-" + version
  end

  filename = strip_extension(filename) + "-" + digest + ext
  return filename, digest
end

# returns a gzip name given filename
def gzip_filename(filename : String) : String

  ext = get_extension(filename)
  case ext
    when EXTENSION_SASS
      ext = ".css"

    when EXTENSION_SCSS
      ext = ".css"

    when EXTENSION_COFFEE
      ext = ".js"

    else
      # Crystal 0.34
  end

  filename = strip_extension(filename) + ext + ".gz"
  return filename
end

# compute the MD5 hash of a file
def compute_md5hash(filename : String)

  lines = File.read_lines(filename)
  data  = lines.join("")

  r = Digest::MD5.hexdigest(data)
  return r
end

def create_gzip_file(source : String, dest : String, permission = 0o755, overwrite : Bool = false)
  check_file(source)

  if source == dest
    return
  end

  if overwrite == false
    if File.exists?(dest)
      report_error("file #{dest} already exist, no action taken")
    end
  end

  File.open(source, "r") do |input_file|
    File.open(dest, "w") do |output_file|
      # 0.35.1 Compress::Gzip::Writer.open(output_file) do |gzip|
      # old code Gzip::Writer.open(output_file) do |gzip|
      # 0.36.1
      Compress::Gzip::Writer.open(output_file) do |gzip|
        IO.copy(input_file, gzip)
      end
    end
  end

  File.chmod(dest, permission)
end

# copies a source file to destination file
def copy_file(source : String, dest : String, permissions = 0o755, overwrite : Bool = false)
  check_file(source)

  if source == dest
    return
  end

  if overwrite == false
    if File.exists?(dest)
      report_error("file #{dest} already exist, no action taken")
    end
  end

  # read and copies contents of source file to destination file
  File.open(source, "r") do |input_file|
    File.write(dest, input_file, permissions)
  end
end

#
# write data to a file
#
def write_file(filename : String, data : Array(String), permissions = 0o755, overwrite : Bool = false)
  write_file(filename, data.join("\n"), permissions,overwrite)
end

def write_file(filename : String, data : String, permissions = 0o755, overwrite : Bool = false)
  if overwrite == false
    if File.exists?(filename)
      report_error("file #{filename} already exist, no action taken")
    end
  end

  File.write(filename, data, permissions)
end

def remove_doubleslashes(filename : String) : String
  return filename.gsub(/\/\//,"/")
end

def remove_doublequotes(filename : String) : String
  return filename.gsub(/\"/,"")
end

def ltrim(s : String) : String
  x = s.gsub(/^\s*/, "")
  return x
end

def rtrim(s : String) : String
  x = s.gsub(/\s*$/, "")
  return x
end

def trim(s : String) : String
  x = ltrim(s)
  x = rtrim(x)
  return x
end

# returns the difference of mtime's of file1 and file2
def compare_mtimes(file1, file2 : String) : Int64
  check_file(file1)
  check_file(file2)

  mtime1 = File.info(file1).modification_time
  mtime2 = File.info(file2).modification_time

  diff = mtime1 - mtime2
  return diff.to_i
end

# create a directory based on the directory part of the file
def create_directory(filename : String, permission = 0o755, is_relative : Bool = false)

  path = filename
  if is_relative
    path = strip_file(filename)
  else
    path = path + "/"
  end

  begin
    Dir.mkdir_p(path,permission)
  rescue
    report_error("cannot create directory #{path}")
  end
end

def stylesheet_link_tag(public_dir : String,filename : String) : String
  manifest = public_dir + "/" + "manifest.json"

  #
  # strip any extension from filename
  # and add ".css"
  #
  filename = strip_extension(filename) + EXTENSION_CSS

  if File.exists?(manifest)
    lines  = File.read_lines(manifest)
    json   = Sprockets::Assets.from_json(lines.join("\n"))

    assetkeys = json.assets.assets
    if assetkeys[filename]?
      s = sprintf("<link rel=\"stylesheet\" type=\"text/css\" href=\"%s\">",assetkeys[filename])
      return s
    end

  end

  return "/assets/#{filename}"
end

def javascript_include_tag(public_dir : String,filename : String) : String
  manifest = public_dir + "/" + "manifest.json"

  #
  # strip any extension from filename
  # and add ".js"
  #
  filename = strip_extension(filename) + EXTENSION_JS

  if File.exists?(manifest)
    lines  = File.read_lines(manifest)
    json   = Sprockets::Assets.from_json(lines.join("\n"))

    assetkeys = json.assets.assets
    if assetkeys[filename]?
      s = sprintf("<script type=\"text/javascript\" src=\"%s\"></script>",assetkeys[filename])
      return s
    end
  end

  return "/assets/#{filename}"
end


def asset_path(public_dir : String,filename : String)

  manifest = public_dir + "/" + "manifest.json"

  if File.exists?(manifest)
    lines  = File.read_lines(manifest)
    json   = Sprockets::Assets.from_json(lines.join("\n"))

    assetkeys = json.assets.assets
    if assetkeys[filename]?
      return assetkeys[filename]
    end

  end

  return "/assets/#{filename}"
end

