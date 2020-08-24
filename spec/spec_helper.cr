require "spec"
require "../src/sprockets/sprockets.cr"

def remove_directory(dirname : String)
  FileUtils.rm_rf(dirname)
  Dir.exists?(dirname).should eq false
end

def new_sprockets(filename : String)
  config = Sprockets::Config.new(filename)
  s      = Sprockets::Sprocket.new(config)
  return s
end

def fileexists(filename : String, flag : Bool)
  File.exists?(filename).should eq flag
end

def direxists(filename : String, flag : Bool)
  Dir.exists?(filename).should eq flag
end
