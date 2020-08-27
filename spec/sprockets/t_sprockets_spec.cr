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
      fileexists(Dir.current + "/spec/sprockets/project1/public/manifest.json",true)

      # test code
      manifest = Dir.current + "/spec/sprockets/project1/public/manifest.json"
      lines  = File.read_lines(manifest)
      json   = Sprockets::Assets.from_json(lines.join("\n"))

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
      fileexists(Dir.current + "/spec/sprockets/project1/public/manifest.json",true)

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
      fileexists(Dir.current + "/spec/sprockets/project1/public/manifest.json",true)

      remove_directory(dest_dir)
    end

    it "static files, digest = false, gzip = false" do
      dest_dir = Dir.current + "/spec/sprockets/project1/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test4.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 7

      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application.js",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/application.css",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/font1.woff",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/assets/logo.png",true)
      fileexists(Dir.current + "/spec/sprockets/project1/public/manifest.json",true)

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
      fileexists(Dir.current + "/spec/sprockets/project1/public/manifest.json",true)

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
      fileexists(Dir.current + "/spec/sprockets/project3/public/manifest.json",true)

      remove_directory(dest_dir)
    end

    it "static files, digest = true, gzip = false, minified true" do
      dest_dir = Dir.current + "/spec/sprockets/project3/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test7.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 124

      fileexists(Dir.current + "/spec/sprockets/project3/public/assets/application-a800c3d673237603065b7dbc9f3597e9.js",true)

      manifest = Dir.current + "/spec/sprockets/project3/public/manifest.json"
      fileexists(manifest,true)
      File.read_lines(manifest).join("\n").should eq "{\"files\":{\"files\":{\"fontawesome-webfont-9662c180d4abb3a1bf0c0be7c0ad87b2.ttf\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.ttf\",\"logical_path\":\"fontawesome-webfont.ttf\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-9662c180d4abb3a1bf0c0be7c0ad87b2.ttf\",\"digest\":\"9662c180d4abb3a1bf0c0be7c0ad87b2\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/FontAwesome.otf\",\"logical_path\":\"FontAwesome.otf\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf\",\"digest\":\"be4df7ae826f6d705c4da7c7d1bd04f3\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"fontawesome-webfont-7d5cbddc1bccb2e92e70e6b77d81be0d.eot\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.eot\",\"logical_path\":\"fontawesome-webfont.eot\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-7d5cbddc1bccb2e92e70e6b77d81be0d.eot\",\"digest\":\"7d5cbddc1bccb2e92e70e6b77d81be0d\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"fontawesome-webfont-96a4c21751cabf61e4edfc373b6dd2bc.woff\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.woff\",\"logical_path\":\"fontawesome-webfont.woff\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-96a4c21751cabf61e4edfc373b6dd2bc.woff\",\"digest\":\"96a4c21751cabf61e4edfc373b6dd2bc\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"fontawesome-webfont-cf2b8047e75debb268481f7275851c4f.svg\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.svg\",\"logical_path\":\"fontawesome-webfont.svg\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-cf2b8047e75debb268481f7275851c4f.svg\",\"digest\":\"cf2b8047e75debb268481f7275851c4f\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"application-a800c3d673237603065b7dbc9f3597e9.js\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/javascripts/application.js\",\"logical_path\":\"application.js\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/application-a800c3d673237603065b7dbc9f3597e9.js\",\"digest\":\"a800c3d673237603065b7dbc9f3597e9\",\"mtime\":\"2020-08-23T01:39:38Z\"},\"icubic-c789cac6da0756bb18376b79cb148844.png\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/images/icubic.png\",\"logical_path\":\"icubic.png\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/icubic-c789cac6da0756bb18376b79cb148844.png\",\"digest\":\"c789cac6da0756bb18376b79cb148844\",\"mtime\":\"2015-01-26T12:50:28Z\"},\"missing-ecbcfd96aeec7066c107239877858207.png\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/images/missing.png\",\"logical_path\":\"missing.png\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/missing-ecbcfd96aeec7066c107239877858207.png\",\"digest\":\"ecbcfd96aeec7066c107239877858207\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-87f371697a801ef578c698dc3818c8a3.ttf\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.ttf\",\"logical_path\":\"glyphicons-halflings-regular.ttf\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-87f371697a801ef578c698dc3818c8a3.ttf\",\"digest\":\"87f371697a801ef578c698dc3818c8a3\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-96694413d6bf72415247b5665de7bb44.svg\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.svg\",\"logical_path\":\"glyphicons-halflings-regular.svg\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-96694413d6bf72415247b5665de7bb44.svg\",\"digest\":\"96694413d6bf72415247b5665de7bb44\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-abcc64ed4616f06f089f182733157ae7.woff\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.woff\",\"logical_path\":\"glyphicons-halflings-regular.woff\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-abcc64ed4616f06f089f182733157ae7.woff\",\"digest\":\"abcc64ed4616f06f089f182733157ae7\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-5d55721d1d1e12245ce98b7e565920cf.eot\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.eot\",\"logical_path\":\"glyphicons-halflings-regular.eot\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-5d55721d1d1e12245ce98b7e565920cf.eot\",\"digest\":\"5d55721d1d1e12245ce98b7e565920cf\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"README-352b7600a1ef13439e6bb133129c7fd0.md\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/README.md\",\"logical_path\":\"README.md\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/README-352b7600a1ef13439e6bb133129c7fd0.md\",\"digest\":\"352b7600a1ef13439e6bb133129c7fd0\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"application-2e7ecac1dafaaa7542871688d6c67dbb.css\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/application.css\",\"logical_path\":\"application.css\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/application-2e7ecac1dafaaa7542871688d6c67dbb.css\",\"digest\":\"2e7ecac1dafaaa7542871688d6c67dbb\",\"mtime\":\"2015-02-25T03:23:24Z\"}}},\"assets\":{\"assets\":{\"fontawesome-webfont.ttf\":\"/assets/fontawesome-webfont-9662c180d4abb3a1bf0c0be7c0ad87b2.ttf\",\"FontAwesome.otf\":\"/assets/FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf\",\"fontawesome-webfont.eot\":\"/assets/fontawesome-webfont-7d5cbddc1bccb2e92e70e6b77d81be0d.eot\",\"fontawesome-webfont.woff\":\"/assets/fontawesome-webfont-96a4c21751cabf61e4edfc373b6dd2bc.woff\",\"fontawesome-webfont.svg\":\"/assets/fontawesome-webfont-cf2b8047e75debb268481f7275851c4f.svg\",\"application.js\":\"/assets/application-a800c3d673237603065b7dbc9f3597e9.js\",\"icubic.png\":\"/assets/icubic-c789cac6da0756bb18376b79cb148844.png\",\"missing.png\":\"/assets/missing-ecbcfd96aeec7066c107239877858207.png\",\"glyphicons-halflings-regular.ttf\":\"/assets/glyphicons-halflings-regular-87f371697a801ef578c698dc3818c8a3.ttf\",\"glyphicons-halflings-regular.svg\":\"/assets/glyphicons-halflings-regular-96694413d6bf72415247b5665de7bb44.svg\",\"glyphicons-halflings-regular.woff\":\"/assets/glyphicons-halflings-regular-abcc64ed4616f06f089f182733157ae7.woff\",\"glyphicons-halflings-regular.eot\":\"/assets/glyphicons-halflings-regular-5d55721d1d1e12245ce98b7e565920cf.eot\",\"README.md\":\"/assets/README-352b7600a1ef13439e6bb133129c7fd0.md\",\"application.css\":\"/assets/application-2e7ecac1dafaaa7542871688d6c67dbb.css\"}}}"

      remove_directory(dest_dir)
    end

    it "static files, digest = true, gzip = true, minified true" do
      dest_dir = Dir.current + "/spec/sprockets/project3/public"
      remove_directory(dest_dir)

      s = new_sprockets("./spec/sprockets/test8.yml")
      s.precompile_assets()
      s.assets_map.size.should eq 124

      fileexists(Dir.current + "/spec/sprockets/project3/public/assets/application-a800c3d673237603065b7dbc9f3597e9.js.gz",true)
      fileexists(Dir.current + "/spec/sprockets/project3/public/assets/application-2e7ecac1dafaaa7542871688d6c67dbb.css.gz",true)


      manifest = Dir.current + "/spec/sprockets/project3/public/manifest.json"
      fileexists(manifest,true)
      File.read_lines(manifest).join("\n").should eq "{\"files\":{\"files\":{\"fontawesome-webfont-9662c180d4abb3a1bf0c0be7c0ad87b2.ttf.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.ttf\",\"logical_path\":\"fontawesome-webfont.ttf\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-9662c180d4abb3a1bf0c0be7c0ad87b2.ttf.gz\",\"digest\":\"9662c180d4abb3a1bf0c0be7c0ad87b2\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/FontAwesome.otf\",\"logical_path\":\"FontAwesome.otf\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf.gz\",\"digest\":\"be4df7ae826f6d705c4da7c7d1bd04f3\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"fontawesome-webfont-7d5cbddc1bccb2e92e70e6b77d81be0d.eot.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.eot\",\"logical_path\":\"fontawesome-webfont.eot\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-7d5cbddc1bccb2e92e70e6b77d81be0d.eot.gz\",\"digest\":\"7d5cbddc1bccb2e92e70e6b77d81be0d\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"fontawesome-webfont-96a4c21751cabf61e4edfc373b6dd2bc.woff.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.woff\",\"logical_path\":\"fontawesome-webfont.woff\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-96a4c21751cabf61e4edfc373b6dd2bc.woff.gz\",\"digest\":\"96a4c21751cabf61e4edfc373b6dd2bc\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"fontawesome-webfont-cf2b8047e75debb268481f7275851c4f.svg.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/fonts/fontawesome-webfont.svg\",\"logical_path\":\"fontawesome-webfont.svg\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/fontawesome-webfont-cf2b8047e75debb268481f7275851c4f.svg.gz\",\"digest\":\"cf2b8047e75debb268481f7275851c4f\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"application-a800c3d673237603065b7dbc9f3597e9.js.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/javascripts/application.coffee\",\"logical_path\":\"application.js\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/application-a800c3d673237603065b7dbc9f3597e9.js.gz\",\"digest\":\"a800c3d673237603065b7dbc9f3597e9\",\"mtime\":\"2020-08-23T01:39:38Z\"},\"icubic-c789cac6da0756bb18376b79cb148844.png.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/images/icubic.png\",\"logical_path\":\"icubic.png\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/icubic-c789cac6da0756bb18376b79cb148844.png.gz\",\"digest\":\"c789cac6da0756bb18376b79cb148844\",\"mtime\":\"2015-01-26T12:50:28Z\"},\"missing-ecbcfd96aeec7066c107239877858207.png.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/images/missing.png\",\"logical_path\":\"missing.png\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/missing-ecbcfd96aeec7066c107239877858207.png.gz\",\"digest\":\"ecbcfd96aeec7066c107239877858207\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-87f371697a801ef578c698dc3818c8a3.ttf.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.ttf\",\"logical_path\":\"glyphicons-halflings-regular.ttf\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-87f371697a801ef578c698dc3818c8a3.ttf.gz\",\"digest\":\"87f371697a801ef578c698dc3818c8a3\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-96694413d6bf72415247b5665de7bb44.svg.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.svg\",\"logical_path\":\"glyphicons-halflings-regular.svg\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-96694413d6bf72415247b5665de7bb44.svg.gz\",\"digest\":\"96694413d6bf72415247b5665de7bb44\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-abcc64ed4616f06f089f182733157ae7.woff.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.woff\",\"logical_path\":\"glyphicons-halflings-regular.woff\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-abcc64ed4616f06f089f182733157ae7.woff.gz\",\"digest\":\"abcc64ed4616f06f089f182733157ae7\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"glyphicons-halflings-regular-5d55721d1d1e12245ce98b7e565920cf.eot.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/bootstrap/glyphicons-halflings-regular.eot\",\"logical_path\":\"glyphicons-halflings-regular.eot\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/glyphicons-halflings-regular-5d55721d1d1e12245ce98b7e565920cf.eot.gz\",\"digest\":\"5d55721d1d1e12245ce98b7e565920cf\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"README-352b7600a1ef13439e6bb133129c7fd0.md.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/README.md\",\"logical_path\":\"README.md\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/README-352b7600a1ef13439e6bb133129c7fd0.md.gz\",\"digest\":\"352b7600a1ef13439e6bb133129c7fd0\",\"mtime\":\"2015-01-26T05:00:01Z\"},\"application-2e7ecac1dafaaa7542871688d6c67dbb.css.gz\":{\"source_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/app/assets/stylesheets/application.scss\",\"logical_path\":\"application.css\",\"dest_path\":\"/home/gummybears/development/crystal/web/sprockets/spec/sprockets/project3/public/assets/application-2e7ecac1dafaaa7542871688d6c67dbb.css.gz\",\"digest\":\"2e7ecac1dafaaa7542871688d6c67dbb\",\"mtime\":\"2015-02-25T03:23:24Z\"}}},\"assets\":{\"assets\":{\"fontawesome-webfont.ttf\":\"/assets/fontawesome-webfont-9662c180d4abb3a1bf0c0be7c0ad87b2.ttf.gz\",\"FontAwesome.otf\":\"/assets/FontAwesome-be4df7ae826f6d705c4da7c7d1bd04f3.otf.gz\",\"fontawesome-webfont.eot\":\"/assets/fontawesome-webfont-7d5cbddc1bccb2e92e70e6b77d81be0d.eot.gz\",\"fontawesome-webfont.woff\":\"/assets/fontawesome-webfont-96a4c21751cabf61e4edfc373b6dd2bc.woff.gz\",\"fontawesome-webfont.svg\":\"/assets/fontawesome-webfont-cf2b8047e75debb268481f7275851c4f.svg.gz\",\"application.js\":\"/assets/application-a800c3d673237603065b7dbc9f3597e9.js.gz\",\"icubic.png\":\"/assets/icubic-c789cac6da0756bb18376b79cb148844.png.gz\",\"missing.png\":\"/assets/missing-ecbcfd96aeec7066c107239877858207.png.gz\",\"glyphicons-halflings-regular.ttf\":\"/assets/glyphicons-halflings-regular-87f371697a801ef578c698dc3818c8a3.ttf.gz\",\"glyphicons-halflings-regular.svg\":\"/assets/glyphicons-halflings-regular-96694413d6bf72415247b5665de7bb44.svg.gz\",\"glyphicons-halflings-regular.woff\":\"/assets/glyphicons-halflings-regular-abcc64ed4616f06f089f182733157ae7.woff.gz\",\"glyphicons-halflings-regular.eot\":\"/assets/glyphicons-halflings-regular-5d55721d1d1e12245ce98b7e565920cf.eot.gz\",\"README.md\":\"/assets/README-352b7600a1ef13439e6bb133129c7fd0.md.gz\",\"application.css\":\"/assets/application-2e7ecac1dafaaa7542871688d6c67dbb.css.gz\"}}}"
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
    remove_directory(dest_dir)
  end
end
