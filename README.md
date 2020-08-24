# sprockets

A really simple assets manager.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     sprockets:
       github: gummybears/sprockets
   ```

2. Run `shards install`

## Usage

```crystal
require "sprockets"
```

To precompile assets, you could write a small program as follows
```
require "sprockets/src/sprockets/config.cr"
require "sprockets/src/sprockets/sprockets.cr"

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
```
given the following configuration
```
mode: development
root_dir: <WORKDIR>

# assets configuration
assets:
  # a flag that enables the creation of gzipped version of compiled assets, along with non-gzipped assets. Set to true by default.
  gzip: false

  # enables the use of SHA256 fingerprints in asset names. Set to true by default.
  digest: true

  # disables the concatenation and compression of assets.
  debug: true
  quiet: true

  # version is optional, but when set is used in SHA256 hash generation, which will force all files to be recompiled.
  version:

  # defines the prefix where assets are served from. Defaults to /assets.
  prefix: /assets

  public:
    dir: public

  source:
    dirs:
      - app/assets
      - lib/assets
      - vendor/assets
```


## Development

TODO: Write development instructions here

## Running the tests

To run the tests, create a symbolic link gummybears
to point to your home or working directory.

$ cd /home; mkdir gummybears
$ cd /home; ln -s $HOME gummybears

## Contributing

1. Fork it (<https://github.com/gummybears/sprockets/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [gummybears](https://github.com/gummybears) - creator and maintainer
