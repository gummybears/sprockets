require "./util.cr"
module Sprockets

  enum AssetType
    StaticAsset
    BundleAsset
    ProcessAsset
    SkipAsset
  end

  class Asset
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

    def rename_to_css()
      @dest_path = strip_extension(@dest_path) + ".css"
    end

    def rename_to_js()
      @dest_path = strip_extension(@dest_path) + ".js"
    end
  end
end
