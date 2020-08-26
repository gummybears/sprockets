require "../spec_helper.cr"
require "../../src/sprockets/sass.cr"

describe "Sass compiler" do

  it "test1.sass" do
    file   = "spec/sass/test1.sass"
    quiet  = true
    sass   = Sprockets::SASS.new(quiet)
    output = sass.preprocess(file).join("\n")
    output.should eq "body div {\n  color: red; }\n"
  end

  it "application.css" do
    file   = "spec/sass/application.css"
    quiet  = true
    sass   = Sprockets::SASS.new(quiet)
    output = sass.preprocess(file).join("\n")
    output.should eq ".v-features, .v-download, .v-forum, .v-contact {\n  min-width: 100%;\n  display: inline-block; }\n\n.v-feature {\n  text-align: center;\n  padding: 0 2rem;\n  margin: 3rem 0; }\n\n.v-feature img {\n  height: 64px; }\n\n.v-logo-image {\n  padding-top: 8px;\n  padding-bottom: 8px; }\n\n.v-sub-header {\n  padding-top: 10px;\n  height: 40px; }\n\n.v-header {\n  height: 65px; }\n\n.v-slider {\n  height: 520px; }\n\n.v-email span i {\n  padding-right: 10px; }\n\n.v-telephone span i {\n  padding-right: 10px; }\n\n.v-contact {\n  height: 100%;\n  min-width: 100%;\n  display: inline-block;\n  padding-top: 32px;\n  padding-bottom: 64px; }\n\n.v-contact-info p {\n  margin: 0;\n  margin-top: 8px;\n  margin-bottom: 8px;\n  padding: 0; }\n\n.v-contact h4 {\n  margin-bottom: 4px; }\n\n.v-footer {\n  position: fixed;\n  left: 0px;\n  bottom: 0px;\n  height: 64px;\n  width: 100%;\n  z-depth: 9999; }\n\n.v-footer .container .row {\n  margin-top: 20px; }\n\n@font-face {\n  font-family: 'Material Icons';\n  font-style: normal;\n  font-weight: 400;\n  src: url(../fonts/google_materialize.woff2) format(\"woff2\"); }\n\n.material-icons {\n  font-family: 'Material Icons';\n  font-weight: normal;\n  font-style: normal;\n  font-size: 24px;\n  line-height: 1;\n  letter-spacing: normal;\n  text-transform: none;\n  display: inline-block;\n  white-space: nowrap;\n  word-wrap: normal;\n  direction: ltr;\n  -webkit-font-feature-settings: 'liga';\n  -webkit-font-smoothing: antialiased; }\n"
  end

  it "application.css (minified)" do
    file     = "spec/sass/application.css"
    quiet    = true
    minified = true
    sass   = Sprockets::SASS.new(quiet,minified)
    output = sass.preprocess(file).join("\n")
    output.should eq ".v-features, .v-download, .v-forum, .v-contact {\n  min-width: 100%;\n  display: inline-block; }\n\n.v-feature {\n  text-align: center;\n  padding: 0 2rem;\n  margin: 3rem 0; }\n\n.v-feature img {\n  height: 64px; }\n\n.v-logo-image {\n  padding-top: 8px;\n  padding-bottom: 8px; }\n\n.v-sub-header {\n  padding-top: 10px;\n  height: 40px; }\n\n.v-header {\n  height: 65px; }\n\n.v-slider {\n  height: 520px; }\n\n.v-email span i {\n  padding-right: 10px; }\n\n.v-telephone span i {\n  padding-right: 10px; }\n\n.v-contact {\n  height: 100%;\n  min-width: 100%;\n  display: inline-block;\n  padding-top: 32px;\n  padding-bottom: 64px; }\n\n.v-contact-info p {\n  margin: 0;\n  margin-top: 8px;\n  margin-bottom: 8px;\n  padding: 0; }\n\n.v-contact h4 {\n  margin-bottom: 4px; }\n\n.v-footer {\n  position: fixed;\n  left: 0px;\n  bottom: 0px;\n  height: 64px;\n  width: 100%;\n  z-depth: 9999; }\n\n.v-footer .container .row {\n  margin-top: 20px; }\n\n@font-face {\n  font-family: 'Material Icons';\n  font-style: normal;\n  font-weight: 400;\n  src: url(../fonts/google_materialize.woff2) format(\"woff2\"); }\n\n.material-icons {\n  font-family: 'Material Icons';\n  font-weight: normal;\n  font-style: normal;\n  font-size: 24px;\n  line-height: 1;\n  letter-spacing: normal;\n  text-transform: none;\n  display: inline-block;\n  white-space: nowrap;\n  word-wrap: normal;\n  direction: ltr;\n  -webkit-font-feature-settings: 'liga';\n  -webkit-font-smoothing: antialiased; }\n"
  end

end
