require "yaml"
require "./util.cr"

module Sprockets
  class Config

    property filename : String
    property modus    : String = ""
    property yaml     : YAML::Any

    def initialize(filename : String)
      @filename = filename
      check_file(filename)

      @yaml = YAML.parse(File.read(filename))
      if @yaml["mode"]?
        @modus = @yaml["mode"].as_s
      end
    end

    def mode() : String
      return @modus
    end

    def read_string(key : String) : String
      r = ""
      begin
        if @yaml[key]?
          r = @yaml[key].as_s
        end
      rescue
      end
      r
    end

    def read_string(key1 : String, key2 : String) : String
      r = ""
      begin
        if @yaml[key1]? && @yaml[key1][key2]?
          r = @yaml[key1][key2].not_nil!.as_s
        end
      rescue
      end
      return r
    end

    def read_string(key1 : String, key2 : String, key3 : String) : String
      r = ""
      begin
        if @yaml[key1]? && @yaml[key1][key2]? && @yaml[key1][key2][key3]?
          r = @yaml[key1][key2][key3].as_s
        end
      rescue
      end
      return r
    end

    def read_int(key : String) : Int32
      r = -1
      begin
        if @yaml[key]?
          r = @yaml[key].as_i
        end
      rescue
      end

      r
    end

    def read_int(key1 : String, key2 : String) : Int32
      r = -1
      begin
        if @yaml[key1]? && @yaml[key1][key2]?
          r = @yaml[key1][key2].as_i
        end
      rescue
      end

      r
    end

    def read_bool(key1 : String, key2 : String) : Bool
      r = false
      begin
        if @yaml[key1]? && @yaml[key1][key2]?
          r = @yaml[key1][key2].as_bool
        end
      rescue
      end
      r
    end

    def read_bool(key1 : String, key2 : String, key3 : String) : Bool
      r = false
      begin
        if @yaml[key1]? && @yaml[key1][key2]? && @yaml[key1][key2][key3]?
          r = @yaml[key1][key2][key3].as_bool
        end
      rescue
      end
      r
    end

    def read_strings(key1 : String, key2 : String, key3 : String) : Array(String)
      r = [] of String
      begin
        if @yaml[key1]? && @yaml[key1][key2]? && @yaml[key1][key2][key3]?
          @yaml[key1][key2][key3].as_a.each do |v|
            r << v.as_s
          end
        end
      rescue
      end
      return r
    end

    def root_dir() : String
      read_string("root_dir")
    end

    def port() : Int32
      read_int(@modus,"port")
    end

    def host()
      read_string(@modus,"host")
    end

    def ssl_host()
      read_string(@modus,"ssl")
    end

    def email()
      read_string(@modus,"email","username")
    end

    def email_smtp()
      read_string(@modus,"email","smtp")
    end

    def email_pop()
      read_string(@modus,"email","pop")
    end

    def database_user()
      read_string(@modus,"database","username")
    end

    def database_name()
      read_string(@modus,"database","name")
    end

    def database_password()
      read_string(@modus,"database","password")
    end

    def database_logmode()
      read_bool(@modus,"database","log_mode")
    end

    def assets_gzip() : Bool
      read_bool("assets","gzip")
    end

    def assets_digest() : Bool
      read_bool("assets","digest")
    end

    def assets_minified() : Bool
      read_bool("assets","minified")
    end

    def assets_quiet() : Bool
      read_bool("assets","quiet")
    end

    def assets_fake_copy() : Bool
      read_bool("assets","fake_copy")
    end

    def assets_debug() : Bool
      read_bool("assets","debug")
    end

    def assets_raise_error() : Bool
      read_bool("assets","raise_runtime_errors")
    end

    def assets_prefix() : String
      x = read_string("assets","prefix")
      if x == ""
        x = "/assets"
      end

      return x
    end

    def assets_version() : String
      read_string("assets","version")
    end

    def assets_public_directory() : String
      x = read_string("assets","public","dir")
      if x == ""
        report_error("public assets directory not set")
      end

      return x
    end

    # list of source directories of our asset files
    def assets_directories() : Array(String)
      read_strings("assets","source","dirs")
    end

    # list of static asset files
    def assets_static_files() : Array(String)
      read_strings("assets","static","files")
    end

    # list of files needing precompilation
    def assets_precompile() : Array(String)
      read_strings("assets","precompile","files")
    end

    # directory where the application stylesheet file is located
    def assets_stylesheet_dir() : String
      read_string("assets","stylesheet","dir")
    end

    # directory where the application javascript file is located
    def assets_javascript_dir() : String
      read_string("assets","javascript","dir")
    end

    # the stylesheet index (or application) file
    def assets_stylesheet_index() : String
      read_string("assets","index","stylesheet")
    end

    # the javascript index (or application) file
    def assets_javascript_index() : String
      read_string("assets","index","javascript")
    end
  end
end
