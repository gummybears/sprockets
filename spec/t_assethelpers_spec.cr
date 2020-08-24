require "./spec_helper.cr"
require "../src/sprockets/util.cr"

describe "Asset helpers" do

  it "asset_path" do
    s = asset_path("logo.png")
    s.should eq "xx"
  end

  it "stylesheet_link_tag" do
    s = stylesheet_link_tag("application")
    s.should eq "xx"
  end

  it "javascript_include_tag" do
    s = javascript_include_tag("application")
    s.should eq "xx"
  end
end
