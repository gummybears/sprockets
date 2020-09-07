require "../spec_helper.cr"
require "../../src/sprockets/sass.cr"

describe "Sass compiler" do

  it "test1.sass" do
    file   = "spec/sass/test1.sass"
    quiet  = true
    sass   = Sprockets::SASS.new(quiet)
    output = sass.preprocess(file).join("\n")
    output.should eq "body div {\ncolor: red; }"
  end

  it "application.css" do
    file   = "spec/sass/application.css"
    quiet  = true
    sass   = Sprockets::SASS.new(quiet)
    output = sass.preprocess(file).join("\n")
    output.should eq  ".v-features, .v-download, .v-forum, .v-contact {\nmin-width: 100%;\ndisplay: inline-block; }\n.v-feature {\ntext-align: center;\npadding: 0 2rem;\nmargin: 3rem 0; }\n.v-feature img {\nheight: 64px; }\n.v-logo-image {\npadding-top: 8px;\npadding-bottom: 8px; }\n.v-sub-header {\npadding-top: 10px;\nheight: 40px; }\n.v-header {\nheight: 65px; }\n.v-slider {\nheight: 520px; }\n.v-email span i {\npadding-right: 10px; }\n.v-telephone span i {\npadding-right: 10px; }\n.v-contact {\nheight: 100%;\nmin-width: 100%;\ndisplay: inline-block;\npadding-top: 32px;\npadding-bottom: 64px; }\n.v-contact-info p {\nmargin: 0;\nmargin-top: 8px;\nmargin-bottom: 8px;\npadding: 0; }\n.v-contact h4 {\nmargin-bottom: 4px; }\n.v-footer {\nposition: fixed;\nleft: 0px;\nbottom: 0px;\nheight: 64px;\nwidth: 100%;\nz-depth: 9999; }\n.v-footer .container .row {\nmargin-top: 20px; }\n@font-face {\nfont-family: 'Material Icons';\nfont-style: normal;\nfont-weight: 400;\nsrc: url(../fonts/google_materialize.woff2) format(\"woff2\"); }\n.material-icons {\nfont-family: 'Material Icons';\nfont-weight: normal;\nfont-style: normal;\nfont-size: 24px;\nline-height: 1;\nletter-spacing: normal;\ntext-transform: none;\ndisplay: inline-block;\nwhite-space: nowrap;\nword-wrap: normal;\ndirection: ltr;\n-webkit-font-feature-settings: 'liga';\n-webkit-font-smoothing: antialiased; }"
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
