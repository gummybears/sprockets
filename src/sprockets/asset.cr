require "json"
require "./util.cr"

module Sprockets

  enum AssetType
    StaticAsset
    BundleAsset
    ProcessAsset
    SkipAsset
  end

  class Assets
    include JSON::Serializable

    property files  : AssetFiles
    property assets : AssetKeys

    def initialize
      @files  = Sprockets::AssetFiles.new
      @assets = Sprockets::AssetKeys.new
    end

    def add_file(logical : String, asset : Asset)
      @files.files[logical] = asset
    end

    def add_asset(logical : String, dest : String)
      @assets.assets[logical] = dest
    end

  end

  class AssetFiles
    include JSON::Serializable

    property files : Hash(String,Asset)

    def initialize
      @files = Hash(String,Asset).new
    end
  end

  class AssetKeys
    include JSON::Serializable

    property assets : Hash(String,String)
    def initialize
      @assets = Hash(String,String).new
    end
  end

  class Asset
    include JSON::Serializable

    @[JSON::Field(key: "type", ignore: true)]
    @[JSON::Field(key: "source_path", ignore: true)]
    @[JSON::Field(key: "dest_path", ignore: true)]

    property type          : AssetType = AssetType::StaticAsset
    property source_path   : String = ""
    property logical_path  : String = ""
    property dest_path     : String = ""
    property digest        : String = ""
    property mtime         : Time

    def initialize
      @mtime    = Time.local
    end

    def to_s : String
      s = [] of String
      s << ""
      s << "asset type   #{type}"
      s << "source_path  #{@source_path}"
      s << "dest_path    #{@dest_path}"
      return s.join("\n")
    end

    def rename_logical_path_to_css()
      @logical_path = strip_extension(@logical_path) + EXTENSION_CSS
    end

    def rename_logical_path_to_js()
      @logical_path = strip_extension(@logical_path) + EXTENSION_JS
    end

    def rename_to_css()
      @dest_path    = strip_extension(@dest_path)    + EXTENSION_CSS
      @source_path  = strip_extension(@source_path)  + EXTENSION_CSS
      @logical_path = strip_extension(@logical_path) + EXTENSION_CSS
    end

    def rename_to_js()
      @dest_path    = strip_extension(@dest_path)    + EXTENSION_JS
      @source_path  = strip_extension(@source_path)  + EXTENSION_JS
      @logical_path = strip_extension(@logical_path) + EXTENSION_JS
    end
  end
end
