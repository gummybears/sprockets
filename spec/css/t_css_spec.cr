require "../spec_helper.cr"
require "../../src/sprockets/css.cr"

describe "CSS" do
  describe "require" do
    it "app1.css" do
      filename = "spec/css/app1.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end

    it "app2.css" do
      filename = "spec/css/app2.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end

    it "app3.css" do
      filename = "spec/css/app3.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end

    it "app4.css" do
      filename = "spec/css/app4.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end

    it "app5.css" do
      filename = "spec/css/app5.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end
  end

  describe "@import" do
    it "app6.css" do
      filename = "spec/css/app6.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end

    it "app7.css" do
      filename = "spec/css/app7.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end

    it "app8.css" do
      filename = "spec/css/app8.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\n  fontsize: 10px;\n}"
    end
  end

  it "application.css" do
    file   = "spec/css/application.css"
    css    = Sprockets::CSS.new
    output = css.preprocess(file).join("\n")
    output.should eq "\n.v-features, .v-download, .v-forum, .v-contact {\n  min-width: 100%;\n  display: inline-block;\n}\n\n.v-feature {\n  text-align: center;\n  padding: 0 2rem;\n  margin: 3rem 0;\n}\n\n.v-feature img {\n  height: 64px;\n}\n\n.v-logo-image {\n  padding-top: 8px;\n  padding-bottom: 8px;\n}\n.v-sub-header {\n  padding-top: 10px;\n  height: 40px;\n}\n\n.v-header {\n  height: 65px;\n}\n\n.v-slider {\n  height: 520px;\n}\n\n.v-email span i {\n  padding-right: 10px;\n}\n\n.v-telephone span i {\n  padding-right: 10px;\n}\n\n.v-contact {\n  height: 100%;\n  min-width: 100%;\n  display: inline-block;\n  padding-top: 32px;\n  padding-bottom: 64px;\n}\n\n.v-contact-info p {\n  margin: 0;\n  margin-top: 8px;\n  margin-bottom: 8px;;\n  padding: 0;\n}\n\n.v-contact h4 {\n  margin-bottom: 4px;\n}\n\n.v-footer {\n  position: fixed;\n  left: 0px;\n  bottom: 0px;\n  height: 64px;\n  width: 100%;\n  z-depth: 9999;\n}\n.v-footer .container .row {\n  margin-top: 20px;\n}\n@font-face {\n  font-family: 'Material Icons';\n  font-style: normal;\n  font-weight: 400;\n  src: url(../fonts/google_materialize.woff2) format('woff2');\n}\n\n.material-icons {\n  font-family: 'Material Icons';\n  font-weight: normal;\n  font-style: normal;\n  font-size: 24px;\n  line-height: 1;\n  letter-spacing: normal;\n  text-transform: none;\n  display: inline-block;\n  white-space: nowrap;\n  word-wrap: normal;\n  direction: ltr;\n  -webkit-font-feature-settings: 'liga';\n  -webkit-font-smoothing: antialiased;\n}"
  end


  describe "require_tree" do
    it "app9.css" do
      filename = "spec/css/app9.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq  "body {\n  fontsize: 10px;\n}\ndiv {\n  height: 800px;\n}\np {\n  color: red;\n}"
    end
  end

end
