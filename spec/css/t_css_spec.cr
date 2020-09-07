require "../spec_helper.cr"
require "../../src/sprockets/css.cr"

describe "CSS" do
  describe "require" do
    it "app1.css" do
      filename = "spec/css/app1.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end

    it "app2.css" do
      filename = "spec/css/app2.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end

    it "app3.css" do
      filename = "spec/css/app3.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end

    it "app4.css" do
      filename = "spec/css/app4.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end

    it "app5.css" do
      filename = "spec/css/app5.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end
  end

  describe "@import" do
    it "app6.css" do
      filename = "spec/css/app6.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end

    it "app7.css" do
      filename = "spec/css/app7.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end

    it "app8.css" do
      filename = "spec/css/app8.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}"
    end
  end

  it "application.css" do
    file   = "spec/css/application.css"
    css    = Sprockets::CSS.new
    output = css.preprocess(file).join("\n")
    output.should eq ".v-features, .v-download, .v-forum, .v-contact {\nmin-width: 100%;\ndisplay: inline-block;\n}\n.v-feature {\ntext-align: center;\npadding: 0 2rem;\nmargin: 3rem 0;\n}\n.v-feature img {\nheight: 64px;\n}\n.v-logo-image {\npadding-top: 8px;\npadding-bottom: 8px;\n}\n.v-sub-header {\npadding-top: 10px;\nheight: 40px;\n}\n.v-header {\nheight: 65px;\n}\n.v-slider {\nheight: 520px;\n}\n.v-email span i {\npadding-right: 10px;\n}\n.v-telephone span i {\npadding-right: 10px;\n}\n.v-contact {\nheight: 100%;\nmin-width: 100%;\ndisplay: inline-block;\npadding-top: 32px;\npadding-bottom: 64px;\n}\n.v-contact-info p {\nmargin: 0;\nmargin-top: 8px;\nmargin-bottom: 8px;;\npadding: 0;\n}\n.v-contact h4 {\nmargin-bottom: 4px;\n}\n.v-footer {\nposition: fixed;\nleft: 0px;\nbottom: 0px;\nheight: 64px;\nwidth: 100%;\nz-depth: 9999;\n}\n.v-footer .container .row {\nmargin-top: 20px;\n}\n@font-face {\nfont-family: 'Material Icons';\nfont-style: normal;\nfont-weight: 400;\nsrc: url(../fonts/google_materialize.woff2) format('woff2');\n}\n.material-icons {\nfont-family: 'Material Icons';\nfont-weight: normal;\nfont-style: normal;\nfont-size: 24px;\nline-height: 1;\nletter-spacing: normal;\ntext-transform: none;\ndisplay: inline-block;\nwhite-space: nowrap;\nword-wrap: normal;\ndirection: ltr;\n-webkit-font-feature-settings: 'liga';\n-webkit-font-smoothing: antialiased;\n}"
  end

  describe "require_tree" do
    it "app9.css" do
      filename = "spec/css/app9.css"
      css = Sprockets::CSS.new
      output = css.preprocess(filename)
      output.join("\n").should eq "body {\nfontsize: 10px;\n}\ndiv {\nheight: 800px;\n}\np {\ncolor: red;\n}"
    end
  end

end
