require "../spec_helper.cr"
require "../../src/sprockets/util.cr"

describe "Asset helpers" do

  #
  # assumption is that we precompile our assets
  # and that they are located in
  # the public/assets directory
  # along with manifest.json
  #

  describe "asset_path" do
    it "logo.png" do
      asset  = "logo.png"
      config = "assets.yml"
      s = asset_path("#{Dir.current}/spec/sprockets/public",asset)
      s.should eq "/assets/logo-c789cac6da0756bb18376b79cb148844.png"
    end

    it "application.css" do
      asset  = "application.css"
      config = "assets.yml"
      s = asset_path("#{Dir.current}/spec/sprockets/public",asset)
      s.should eq "/assets/application-aee72038731bb7838c11204dc56265d5.css"
    end

    it "application.js" do
      asset  = "application.js"
      config = "assets.yml"
      s = asset_path("#{Dir.current}/spec/sprockets/public",asset)
      s.should eq "/assets/application-67a278a0863666a39529b41e31cd49d6.js"
    end
  end

  it "stylesheet_link_tag" do
    asset  = "application.css"
    config = "assets.yml"
    s = stylesheet_link_tag("#{Dir.current}/spec/sprockets/public","application.css")
    s.should eq "<link rel=\"stylesheet\" type=\"text/css\" href=\"/assets/application-aee72038731bb7838c11204dc56265d5.css\">"
  end

  it "javascript_include_tag" do
    asset  = "application.js"
    config = "assets.yml"
    s = javascript_include_tag("#{Dir.current}/spec/sprockets/public","application.js")
    s.should eq "<script type=\"text/javascript\" src=\"/assets/application-67a278a0863666a39529b41e31cd49d6.js\"></script>"
  end
end
