require "../spec_helper.cr"
require "../../src/sprockets/sass.cr"

describe "Sass compiler" do

  it "test1.sass" do
    file   = "spec/sass/test1.sass"
    quiet  = true
    sass   = Sprockets::SASS.new(quiet)
    output = sass.preprocess(file).join("\n")
    output.should eq "body div {\n  color: red; }"
  end

  it "application.css" do
    file   = "spec/sass/application.css"
    quiet  = true
    sass   = Sprockets::SASS.new(quiet)
    output = sass.preprocess(file).join("\n")
    output.should eq ".v-features, .v-download, .v-forum, .v-contact {\n  min-width: 100%;\n  display: inline-block; }\n.v-feature {\n  text-align: center;\n  padding: 0 2rem;\n  margin: 3rem 0; }\n.v-feature img {\n  height: 64px; }\n.v-logo-image {\n  padding-top: 8px;\n  padding-bottom: 8px; }\n.v-sub-header {\n  padding-top: 10px;\n  height: 40px; }\n.v-header {\n  height: 65px; }\n.v-slider {\n  height: 520px; }\n.v-email span i {\n  padding-right: 10px; }\n.v-telephone span i {\n  padding-right: 10px; }\n.v-contact {\n  height: 100%;\n  min-width: 100%;\n  display: inline-block;\n  padding-top: 32px;\n  padding-bottom: 64px; }\n.v-contact-info p {\n  margin: 0;\n  margin-top: 8px;\n  margin-bottom: 8px;\n  padding: 0; }\n.v-contact h4 {\n  margin-bottom: 4px; }\n.v-footer {\n  position: fixed;\n  left: 0px;\n  bottom: 0px;\n  height: 64px;\n  width: 100%;\n  z-depth: 9999; }\n.v-footer .container .row {\n  margin-top: 20px; }\n@font-face {\n  font-family: 'Material Icons';\n  font-style: normal;\n  font-weight: 400;\n  src: url(../fonts/google_materialize.woff2) format(\"woff2\"); }\n.material-icons {\n  font-family: 'Material Icons';\n  font-weight: normal;\n  font-style: normal;\n  font-size: 24px;\n  line-height: 1;\n  letter-spacing: normal;\n  text-transform: none;\n  display: inline-block;\n  white-space: nowrap;\n  word-wrap: normal;\n  direction: ltr;\n  -webkit-font-feature-settings: 'liga';\n  -webkit-font-smoothing: antialiased; }"
  end

  it "application.css (minified)" do
    file     = "spec/sass/application.css"
    quiet    = true
    minified = true
    sass   = Sprockets::SASS.new(quiet,minified)
    output = sass.preprocess(file).join("\n")
    output.should eq ".v-features,.v-download,.v-forum,.v-contact{min-width:100%;display:inline-block}.v-feature{text-align:center;padding:0 2rem;margin:3rem 0}.v-feature img{height:64px}.v-logo-image{padding-top:8px;padding-bottom:8px}.v-sub-header{padding-top:10px;height:40px}.v-header{height:65px}.v-slider{height:520px}.v-email span i{padding-right:10px}.v-telephone span i{padding-right:10px}.v-contact{height:100%;min-width:100%;display:inline-block;padding-top:32px;padding-bottom:64px}.v-contact-info p{margin:0;margin-top:8px;margin-bottom:8px;padding:0}.v-contact h4{margin-bottom:4px}.v-footer{position:fixed;left:0px;bottom:0px;height:64px;width:100%;z-depth:9999}.v-footer .container .row{margin-top:20px}@font-face{font-family:'Material Icons';font-style:normal;font-weight:400;src:url(../fonts/google_materialize.woff2) format(\"woff2\")}.material-icons{font-family:'Material Icons';font-weight:normal;font-style:normal;font-size:24px;line-height:1;letter-spacing:normal;text-transform:none;display:inline-block;white-space:nowrap;word-wrap:normal;direction:ltr;-webkit-font-feature-settings:'liga';-webkit-font-smoothing:antialiased}"
  end

end
