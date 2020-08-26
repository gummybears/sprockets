require "../spec_helper.cr"
require "../../src/sprockets/config.cr"

describe "Config" do

  it "gets server mode" do
    config  = Sprockets::Config.new("./spec/config/test1.yml")
    lv_mode = config.mode()
    lv_mode.should eq "development"
  end

  it "gets server root directory" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_root = config.root_dir()
    lv_root.should eq "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/"
  end

  it "gets the server port" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_port = config.port()
    lv_port.should eq 8001
  end

  it "gets host name" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_host = config.host()
    lv_host.should eq "localhost"
  end

  it "gets SSL host name" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_ssl_host = config.ssl_host()
    lv_ssl_host.should eq "localhost"
  end

  describe "mode = development" do

    it "gets email username " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.email()
      lv_value.should eq "development_user"
    end

    it "gets email smtp " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.email_smtp()
      lv_value.should eq "development_smtp"
    end

    it "gets email pop " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.email_pop()
      lv_value.should eq "development_pop"
    end

    it "gets database username " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.database_user()
      lv_value.should eq "development_user"
    end

    it "gets database name " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.database_name()
      lv_value.should eq "development_name"
    end

    it "gets database password " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.database_password()
      lv_value.should eq "12345"
    end

    it "gets database log_mode " do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_value = config.database_logmode()
      lv_value.should eq false
    end
  end

  describe "assets gzip" do
    it "test1.yml" do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_x = config.assets_gzip()
      lv_x.should eq false
    end

    it "test2.yml" do
      config = Sprockets::Config.new("./spec/config/test2.yml")
      lv_x = config.assets_gzip()
      lv_x.should eq true
    end

  end

  describe "assets digest" do
    it "test1.yml" do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_x = config.assets_digest()
      lv_x.should eq true
    end

    it "test2.yml" do
      config = Sprockets::Config.new("./spec/config/test2.yml")
      lv_x = config.assets_digest()
      lv_x.should eq true
    end

  end

  it "assets quiet" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_x = config.assets_quiet()
    lv_x.should eq true
  end

  it "assets debug" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_x = config.assets_debug()
    lv_x.should eq true
  end

  describe "assets prefix" do
    it "is set" do
      config = Sprockets::Config.new("./spec/config/test1.yml")
      lv_x = config.assets_prefix()
      lv_x.should eq "/assets"
    end

    it "not set" do
      config = Sprockets::Config.new("./spec/config/test2.yml")
      lv_x = config.assets_prefix()
      lv_x.should eq "/assets"
    end

  end

  it "assets version" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_x = config.assets_version()
    lv_x.should eq "1.2.3"
  end

  it "assets raise runtime error" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    lv_x = config.assets_raise_error()
    lv_x.should eq true
  end

  it "assets source directories" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    dir = config.assets_directories()
    dir.should eq ["app/assets","lib/assets","vendor/assets"]
  end

  it "assets public directory" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    dir = config.assets_public_directory()
    dir.should eq "public"
  end

  it "get assets precompile files" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    files  = config.assets_precompile()
    files.should eq ["application.css", "application.js"]
  end

  it "get assets static files" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    dir = config.assets_static_files()
    dir.should eq ["/assets/images/image1.jpg", "/assets/images/image2.jpg"]
  end

  it "get name of assets stylesheet dir" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    dir = config.assets_stylesheet_dir()
    dir.should eq "stylesheets"
  end

  it "get name of assets javascripts dir" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    dir = config.assets_javascript_dir()
    dir.should eq "javascripts"
  end

  it "get name of stylesheet index file" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    file = config.assets_stylesheet_index()
    file.should eq "application.css"
  end

  it "get name of javascript index file" do
    config = Sprockets::Config.new("./spec/config/test1.yml")
    file = config.assets_javascript_index()
    file.should eq "application.js"
  end

end
