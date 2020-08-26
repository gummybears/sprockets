require "./sprockets.cr"

args = ARGV

if args.size == 0 || args.size > 1
  puts "usage : precompile config.yml"
  exit
end

filename = args[0]
if File.exists?(filename) == false
  puts "file #{filename} not found"
  exit
end

config = Sprockets::Config.new(filename)
s = Sprockets::Sprocket.new(config)
s.precompile_assets()

