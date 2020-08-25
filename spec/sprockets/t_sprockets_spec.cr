require "../spec_helper.cr"
require "../../src/sprockets.cr"
require "file_utils"

describe "Sprockets precompile" do

  it "new" do
    s = new_sprockets("./spec/sprockets/test1.yml")

    s.mode.should          eq "development"
    s.debug.should         eq true
    s.gzip.should          eq false
    s.digest.should        eq true
    s.quiet.should         eq true
    s.raise_runtime.should eq true
    s.version.should       eq ""

    s.root_dir.should      eq "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/"
    s.prefix.should        eq "/assets"
    s.public_dir.should    eq "public"
    s.dest_dir.should      eq "public/assets"

    s.source_dirs.size.should eq 3
    s.source_dirs.should eq ["app/assets", "lib/assets", "vendor/assets"]
  end

  describe "public/assets directory (abs/rel)" do
    it "absolute path" do
      s = new_sprockets("./spec/sprockets/test6.yml")
      s.public_dir.should eq "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public"
      s.dest_dir.should   eq "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets"
    end

    it "relative path to root_dir" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      s.public_dir.should eq "public"
      s.dest_dir.should eq "public/assets"
    end
  end

  describe "determine_asset_type(asset : String) : AssetType" do
    it "testdata/app/assets/javascripts/application.js" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      asset_type = s.determine_asset_type("testdata/app/assets/javascripts/application.js")
      asset_type.should eq Sprockets::AssetType::BundleAsset
    end

    it "testdata/app/assets/javascripts/app.coffee" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      asset_type = s.determine_asset_type("testdata/app/assets/javascripts/app.coffee")
      asset_type.should eq Sprockets::AssetType::ProcessAsset
    end

    it "testdata/app/assets/vue/app.vue" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      asset_type = s.determine_asset_type("testdata/app/assets/vue/app.vue")
      asset_type.should eq Sprockets::AssetType::ProcessAsset
    end

    it "testdata/app/assets/application.css" do
      s = new_sprockets("./spec/sprockets/test1.yml")

      asset_type = s.determine_asset_type("testdata/app/assets/stylesheets/application.css")
      asset_type.should eq Sprockets::AssetType::BundleAsset
    end

    it "testdata/app/assets/stylesheets/app.css" do
      s = new_sprockets("./spec/sprockets/test1.yml")

      asset_type = s.determine_asset_type("testdata/app/assets/stylesheets/app.css")
      asset_type.should eq Sprockets::AssetType::SkipAsset
    end

    it "testdata/app/assets/stylesheets/app.sass" do
      s = new_sprockets("./spec/sprockets/test1.yml")

      asset_type = s.determine_asset_type("testdata/app/assets/stylesheets/app.sass")
      asset_type.should eq Sprockets::AssetType::ProcessAsset
    end

    it "testdata/app/assets/stylesheets/app.scss" do
      s = new_sprockets("./spec/sprockets/test1.yml")

      asset_type = s.determine_asset_type("testdata/app/assets/stylesheets/app.scss")
      asset_type.should eq Sprockets::AssetType::ProcessAsset
    end

    it "testdata/app/assets/woff.toff" do
      s = new_sprockets("./spec/sprockets/test1.yml")

      asset_type = s.determine_asset_type("testdata/app/assets/fonts/woff.toff")
      asset_type.should eq Sprockets::AssetType::StaticAsset
    end
  end

  describe "compute_target_path(filename : String) : String" do
    it "app/assets/javascripts/application.js" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      s.digest   = false

      dir,digest = s.compute_target_path("/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/app/assets/javascripts/application.js")
      target_dir = "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/public/assets/application.js"

      dir.should eq target_dir
    end

    it "app/assets/javascripts/app.coffee" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      s.digest = false

      dir,digest = s.compute_target_path("/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/app/assets/javascripts/app.coffee")

      target_dir = "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/public/assets/app.coffee"
      dir.should eq target_dir
    end

    it "app/assets/images/logo.png" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      s.digest = false

      dir,digest = s.compute_target_path("/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/app/assets/images/logo.png")

      target_dir = "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/public/assets/logo.png"
      dir.should eq target_dir
    end

    it "app/assets/woff.toff" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      dir,digest = s.compute_target_path("/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/app/assets/stylesheets/fonts/roboto/font1.woff")
      target_dir = "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/public/assets/font1-ecf9dae5bf946637352c47edf9949512.woff"
      dir.should eq target_dir
    end


    it "testdata/app/assets/application.css" do
      s = new_sprockets("./spec/sprockets/test1.yml")
      dir,digest = s.compute_target_path("/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/app/assets/stylesheets/application.css")
      dir.should eq "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/public/assets/application-aee72038731bb7838c11204dc56265d5.css"
    end
  end

  it "build_list() : Array(Asset)" do
    s = new_sprockets("./spec/sprockets/test1.yml")

    s.assets_map.size.should eq 7
    s.assets_map.has_key?("errors.js").should eq true
    s.assets_map.has_key?("application.js").should eq true
    s.assets_map.has_key?("logo.png").should eq true
    s.assets_map.has_key?("custom.css").should eq true
    s.assets_map.has_key?("google.css").should eq true
    s.assets_map.has_key?("application.css").should eq true
    s.assets_map["application.css"].source_path.should eq "/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project1/app/assets/stylesheets/application.css"
    s.assets_map["application.css"].type.should eq Sprockets::AssetType::BundleAsset
  end

  describe "precompile_assets()" do

    it "static files, digest = true, gzip = false" do
      dest_dir = Dir.current + "/spec/sprockets/project1/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test1.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 7

      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/font1-ecf9dae5bf946637352c47edf9949512.woff",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/logo-c789cac6da0756bb18376b79cb148844.png",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application-aee72038731bb7838c11204dc56265d5.css",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application-67a278a0863666a39529b41e31cd49d6.js",true)

      remove_directory(dest_dir)
    end

    it "static files, digest = true, gzip = true" do
      dest_dir = Dir.current + "/spec/sprockets/project1/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test2.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 7

      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application-67a278a0863666a39529b41e31cd49d6.js.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application-aee72038731bb7838c11204dc56265d5.css.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/font1-ecf9dae5bf946637352c47edf9949512.woff.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/logo-c789cac6da0756bb18376b79cb148844.png.gz",true)

      # cleanup
      remove_directory(dest_dir)
    end

    it "static files, digest = false, gzip = true" do
      dest_dir = Dir.current + "/spec/sprockets/project1/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test3.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 7

      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application.js.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application.css.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/font1.woff.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/logo.png.gz",true)

      # cleanup
      remove_directory(dest_dir)
    end

    it "static files, digest = false, gzip = false" do
      dest_dir = Dir.current + "/spec/sprockets/project1/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test4.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 7

      # static files
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application.js",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application.css",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/font1.woff",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/logo.png",true)

      # cleanup
      remove_directory(dest_dir)
    end

    it "static files, digest = true, gzip = false (with asset expiry, version)" do
      dest_dir = Dir.current + "/spec/sprockets/project1/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test5.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 7

      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/font1-ecf9dae5bf946637352c47edf9949512-123.woff",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/logo-c789cac6da0756bb18376b79cb148844-123.png",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application-aee72038731bb7838c11204dc56265d5-123.css",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application-67a278a0863666a39529b41e31cd49d6-123.js",true)

      # cleanup
      remove_directory(dest_dir)
    end

    it "static files, digest = true, gzip = false, absolute public path" do
      dest_dir   = Dir.current + "/spec/sprockets/project3/public"
      assets_dir = Dir.current + "/spec/sprockets/project3/public/assets"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test6.yml")
      direxists(dest_dir,true)
      direxists(assets_dir,true)

      s.precompile_assets()
      s.assets_map.size.should eq 124

      File.exists?(Dir.current + "/spec/sprockets/project3/public/assets/FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf").should eq true

      # cleanup
      remove_directory(dest_dir)
    end
  end

  it "manifest.json" do
    dest_dir   = Dir.current + "/spec/sprockets/project1/public"
    assets_dir = Dir.current + "/spec/sprockets/project1/public/assets"
    remove_directory(dest_dir)

    s = new_sprockets("./spec/sprockets/test1.yml")
    s.precompile_assets()

    File.exists?(Dir.current + "/spec/sprockets/project1/public/manifest.json").should eq true
  end
end
