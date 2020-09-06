require "./asset.cr"
require "./config.cr"
require "./css.cr"
require "./js.cr"
require "./coffee.cr"
require "./sass.cr"

EXTENSION_CSS    = ".css"
EXTENSION_JS     = ".js"
EXTENSION_SCSS   = ".scss"
EXTENSION_SASS   = ".sass"
EXTENSION_COFFEE = ".coffee"
EXTENSION_VUE    = ".vue"
EXTENSION_GZIP   = ".gz"

module Sprockets

  class Sprocket

    property source_dirs       : Array(String)

    property root_dir          : String = ""
    property public_dir        : String = ""

    property dest_dir          : String = ""
    property assets_map        : Hash(String,Sprockets::Asset)

    property debug             : Bool   = false
    property gzip              : Bool   = false
    property digest            : Bool   = false
    property raise_runtime     : Bool   = false
    property quiet             : Bool   = false
    property fake_copy         : Bool   = false
    property is_relative       : Bool   = false
    property minified          : Bool   = false

    property mode              : String = ""
    property prefix            : String = ""
    property version           : String = ""

    def initialize(config : Sprockets::Config)
      @source_dirs   = [] of String
      @assets        = [] of String
      @assets_map    = Hash(String,Sprockets::Asset).new

      @mode          = config.mode()
      @debug         = config.assets_debug()
      @gzip          = config.assets_gzip()
      @digest        = config.assets_digest()
      @quiet         = config.assets_quiet()
      @fake_copy     = config.assets_fake_copy()
      @version       = config.assets_version()
      @raise_runtime = config.assets_raise_error()
      @minified      = config.assets_minified()

      #
      # asset prefix, used in building the target directory
      #
      @prefix         = config.assets_prefix()
      @root_dir       = config.root_dir()
      @source_dirs    = config.assets_directories()
      @public_dir     = config.assets_public_directory()

      if @root_dir == ""
        report_error("application root directory not set")
      end
      check_dir(@root_dir)

      if @public_dir == ""
        report_error("assets public directory not set")
      end

      if @prefix == ""
        report_error("assets prefix not set")
      end

      if @source_dirs.size() == 0
        report_error("assets directories not set")
      end

      set_dest_dir()
      set_relative()

      if @quiet == false
        report_info("create directory #{@dest_dir}")
      end
      create_directory(@dest_dir,0o755,@is_relative)

      build_list()
    end

    #
    # set the destination directory
    #
    def set_dest_dir()
      @dest_dir = @public_dir + @prefix
    end

    #
    # does public dir contains a '/' at the beginning
    # if so we are dealing with an absolute path
    #
    def set_relative()
      if @public_dir =~ /^\//
        @is_relative = false
      else
        @is_relative = true
      end
    end

    #
    # build a list of assets
    #
    def build_list()

      (0..@source_dirs.size() - 1).each do |i|
        dir = @root_dir +  "/" + @source_dirs[i]
        dir = remove_doubleslashes(dir)

        #
        # if the source directory does not exist
        # we don't do anything, no processing but also no errors
        #
        if Dir.exists?(dir)
          walk_dir(dir)
        end
      end
    end

    #
    # get a list of all the files in the current directory
    #
    def walk_dir(path : String)

      files = Dir.children(path)

      (0..files.size() - 1).each do |i|
        dir = path + "/" + files[i]
        if is_directory?(dir)
          walk_dir(dir)
        else

          filename           = files[i]
          full_filename      = path + "/" + filename
          asset              = Sprockets::Asset.new()
          asset.logical_path = remove_doubleslashes(filename)
          asset.source_path  = remove_doubleslashes(full_filename)
          asset.mtime        = File.info(full_filename).modification_time
          asset.type         = determine_asset_type(filename)
          asset.dest_path,asset.digest = compute_target_path(asset.source_path)

          @assets_map[filename] = asset

        end
      end
    end # walk_dir

    #
    # create manifest file
    #
    def create_manifest()

      # determine the public directory
      dest = ""
      if @is_relative
        dest = @root_dir + @public_dir
      else
        dest = @public_dir
      end

      manifest = Sprockets::Assets.new
      @assets_map.each do |k,v|

        if v.type == Sprockets::AssetType::BundleAsset || v.type == Sprockets::AssetType::StaticAsset

          key            = strip_directory(v.dest_path)
          asset_location = @prefix + "/" + key

          manifest.add_file(key,v)
          manifest.add_asset(v.logical_path,asset_location)

        end
      end

      filename = dest + "/manifest.json"
      create_directory(dest,0o755,false)
      write_file(filename, manifest.to_json, 0o644, true)
    end

    def compute_target_path(filename : String) : {String,String}

      source = filename
      dest   = ""
      digest = ""
      if @digest && @gzip
        dest,digest = digest_filename(source,@version)
        dest = gzip_filename(dest)
      elsif @digest
        dest,digest = digest_filename(source,@version)
      elsif @gzip
        dest = gzip_filename(source)
      else
        dest = filename
      end

      if @is_relative
        dest = @root_dir + @dest_dir + "/" + strip_directory(dest)
      else
        dest = @dest_dir + "/" + strip_directory(dest)
      end

      return dest,digest
    end

    #
    # determine asset type
    #
    def determine_asset_type(asset : String) : Sprockets::AssetType

      if asset =~ /application\.css/ || asset =~ /application\.scss/ || asset =~ /application\.sass/ || asset =~ /application\.js/ || asset =~ /application\.coffee/
        return Sprockets::AssetType::BundleAsset
      end

      if asset =~ /\.scss|\.sass|\.coffee|\.vue/
        return Sprockets::AssetType::ProcessAsset
      end

      if asset =~ /\.js|\.css/
        return Sprockets::AssetType::SkipAsset
      end

      return Sprockets::AssetType::StaticAsset
    end

    #
    # this function copies all the directories/files within the assets directory @source_dirs
    # to the public directory (@public_dir)
    #
    # exception : for Javascript and CSS stylesheets the assets are precompiled
    # need to check each of these assets, they contain Sprockets directives
    # if so need to exclude the required files from being copied
    #
    def precompile_assets()

      #
      # precompile an asset
      #
      @assets_map.each do |k,v|
        if @quiet == false
          report_info("precompiling asset   #{v.source_path} to #{v.dest_path}") if v.type == Sprockets::AssetType::BundleAsset
          report_info("skipping asset       #{v.source_path}") if v.type == Sprockets::AssetType::SkipAsset
          report_info("copying static asset #{v.source_path} to #{v.dest_path}") if v.type == Sprockets::AssetType::StaticAsset
        end

        precompile_asset(v)
      end

      create_manifest()

    end # precompile_assets

    #
    # precompile asset
    #
    def precompile_asset(asset : Sprockets::Asset)

      case asset.type
        when Sprockets::AssetType::StaticAsset
          copy_static_asset_file(asset)

        when Sprockets::AssetType::BundleAsset
          process_file(asset)

        else
          # Crystal 0.34


      end
    end # precompile asset

    def process_file(asset : Sprockets::Asset)

      ext = get_extension(asset.source_path)
      case ext

        when EXTENSION_JS
          x = Sprockets::JS.new(@quiet,@minified)
          output = x.preprocess(asset.source_path)
          create_all_files(asset,output)

        when EXTENSION_COFFEE
          x = Sprockets::Coffee.new(@quiet,@minified)
          output = x.preprocess(asset.source_path)
          create_all_files(asset,output)

        when EXTENSION_CSS
          x = Sprockets::CSS.new(@quiet,@minified)
          output = x.preprocess(asset.source_path)
          create_all_files(asset,output)

        when EXTENSION_SCSS
          x = Sprockets::SASS.new(@quiet,@minified)
          output = x.preprocess(asset.source_path)
          create_all_files(asset,output)

        when EXTENSION_SASS
          x = Sprockets::SASS.new(@quiet,@minified)
          output = x.preprocess(asset.source_path)
          create_all_files(asset,output)

        else
          report_error("unknown asset")
      end # case

    end

    #
    # determines where or not to copy the asset
    #
    def must_copy_file(asset : Sprockets::Asset) : Bool

      source_file = asset.source_path
      check_file(source_file)

      dest_file,digest = compute_target_path(source_file)

      #
      # the destination file is not present, cannot do comparison
      # return true
      #
      if File.exists?(dest_file) == false
        return true
      end

      #
      # determine the access times of the asset in the asset map
      # and compare this with the access time of the destination file (when present)
      # if there is a time difference ie we have a newer version of
      # our asset, return true ie we must copy the new file
      #
      diff = compare_mtimes(asset.source_path, dest_file)
      if diff > 0
        return true
      end

      return false
    end

    def debug_create_file(filename : String)
      if @quiet == false
        report_info("create file #{filename}")
      end
    end

    def debug_copy_file(source : String, dest : String)
      if @quiet == false
        report_info("copy file #{source} to #{dest}")
      end
    end

    def debug_create_directory(dirname : String)

      path = strip_file(dirname)
      if @quiet == false
        # old code report_info("create directory #{dirname}")
        if Dir.exists?(path) == false
          report_info("create directory #{path}")
        end
      end
    end

    def copy_static_asset_file(asset : Sprockets::Asset) : Bool

      if @is_relative
        debug_create_directory(asset.dest_path)
        create_directory(asset.dest_path,0o755,@is_relative)
      end

      if @digest && @gzip
        debug_create_file(asset.dest_path)
        create_gzip_file(asset.source_path,asset.dest_path,0o644,true)
      elsif @digest
        debug_create_file(asset.dest_path)
        copy_file(asset.source_path,asset.dest_path, 0o644, true)
      elsif @gzip
        debug_create_file(asset.dest_path)
        create_gzip_file(asset.source_path,asset.dest_path,0o644,true)
      else
        debug_copy_file(asset.source_path,asset.dest_path)
        copy_file(asset.source_path,asset.dest_path, 0o644, true)
      end

      return true
    end

    #
    # found bug when gzip is true and
    # precompiling a Coffeescript of Sass file
    # in the old situation the source file was just g'zipped
    # and not the compiled version of the source file
    #
    def create_all_files(asset : Sprockets::Asset, data : Array(String))

      if @fake_copy
        if @quiet == false
          report_info("copying #{asset.source_path} to #{asset.dest_path} (simulate)")
        end

        return
      end

      if must_copy_file(asset) == false
        return
      end

      if @is_relative
        debug_create_directory(asset.dest_path)
        create_directory(asset.dest_path,0o755,@is_relative)
      end

      # rename asset
      rename_asset(asset)

      debug_create_file(asset.dest_path)

      #
      # if minified is true
      # left/right strip spaces from
      # data
      #
      if @minified
        (0..data.size-1).each do |i|
          data[i] = trim(data[i])
        end
      end

      if @digest && @gzip

        # create tmp output file
        filename = "/tmp/#{strip_directory(asset.source_path)}"
        create_file(filename,data)
        create_gzip_file(filename,asset.dest_path,0o644,true)

      elsif @gzip

        # create tmp output file
        filename = "/tmp/#{strip_directory(asset.source_path)}"
        create_file(filename,data)
        create_gzip_file(filename,asset.dest_path,0o644,true)

      elsif @digest
        create_file(asset.dest_path,data)
      else
        create_file(asset.dest_path,data)
      end
    end

    #
    # minify data
    #
    def minify(data : Array(String) ) : Array(String)

      output = [] of String
      if @minified
        (0..data.size-1).each do |i|
          #data[i] = trim(data[i])
          output << trim(data[i])
        end
      end

      return output
    end

    def rename_asset(asset : Sprockets::Asset)

      ext = get_extension(asset.dest_path)
      if ext == EXTENSION_GZIP

        #
        # remove .gz
        #
        filename = asset.dest_path.gsub(/\.gz/,"")
        ext = get_extension(filename)

        case ext
          when EXTENSION_CSS
            asset.rename_logical_path_to_css()
          when EXTENSION_JS
            asset.rename_logical_path_to_js()
          else
        end # case

        return
      end

      case ext
        when EXTENSION_SASS
          asset.rename_to_css()

        when EXTENSION_SCSS
          asset.rename_to_css()

        when EXTENSION_COFFEE
          asset.rename_to_js()


        else
          # Crystal 0.34

      end # case
    end

    def create_file(dest : String, data : Array(String))

      if @fake_copy
        if @quiet == false
          report_info("create file #{dest}")
        end

        return
      end

      s = ""
      if @minified
        s = data.join(" ")
      else
        s = data.join("\n")
      end
      write_file(dest, s, 0o644, true)
    end
  end
end
