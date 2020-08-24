//  <router-link class="waves-effect" exact to="/">gummybears</router-link>
var v_logo = Vue.component("v-logo", {
  template: `
    <a href="http://www.gummybears.nl">gummybears</a>
  `,
});

var v_main_menu = Vue.component("v-main-menu", {
  template: `
    <ul id="nav-mobile" class="v-main-menu right">
      <li><router-link class="waves-effect" exact to="/features">Features</router-link></li>
      <li><router-link class="waves-effect" exact to="/download">Download</router-link></li>
      <li><router-link class="waves-effect" exact to="/contact">Contact</router-link></li>
      <li><router-link class="waves-effect" exact to="/forum">Forum</router-link></li>
    </ul>
  `,

});

var v_menu = Vue.component("v-menu", {
  template: `
    <nav class="purple darken-2 z-depth-0">
      <div class="nav-wrapper">
        <v-logo></v-logo>
        <v-main-menu></v-main-menu>
       </div>
    </nav>
  `,
});

//      <span><i class="material-icons prefix tiny white-text">email</i><a href="#" class="white-text">info@gummybears.nl</a></span>
var v_email = Vue.component("v-email", {
  props : ['email'],
  template: `
    <div class="v-email col">
      <span><i class="material-icons prefix tiny white-text">email</i><a href="#" class="white-text">{{email}}</a></span>
    </div>
  `
});

// <span class="white-text"><i class="material-icons prefix tiny white-text">phone</i>0633101066</span>

var v_telephone = Vue.component("v-telephone", {
  props : ['telephone'],
  template: `
    <div class="v-telephone col">
      <span class="white-text"><i class="material-icons prefix tiny white-text">phone</i>{{telephone}}</span>
    </div>
  `
});

var v_sub_header = Vue.component("v-sub-header", {

  template: `
    <div class="v-sub-header #4a148c purple darken-4">
      <div class="container">
        <div class="row">
          <v-email email="info@xyz.nl"></v-email>
          <v-telephone telephone="(0)31 06 12 34 56 78"></v-telephone>
        </div>
      </div>
    </div>
  `,
});

var v_header = Vue.component("v-header", {

  template: `
    <div class="v-header #7b1fa2 purple darken-2">
      <div class="container">
        <v-menu></v-menu>
      </div>
    </div>
  `,
});

var v_prev_button = Vue.component("v-prev-button", {

  template: `
    <div class="v-prev-button">
    </div>
  `,
});

var v_next_button = Vue.component("v-next-button", {

  template: `
    <div class="v-next-button">
    </div>
  `,
});

var v_preview = Vue.component("v-preview", {

  template: `
    <div class="v-preview">
    </div>
  `,
});

var v_footer = Vue.component("v-footer", {

  template: `
    <div class="v-footer #4a148c purple darken-4">
      <div class="container">
        <div class="row">
          <span class="white-text">&copy; 2008-2017 | <a href="http://www.gummybears.nl">www.gummybears.nl</a> | All rights reserved</span>
        </div>
      </div>
    </div>
  `,
});

var v_slider = Vue.component("v-slider", {

  template: `
    <div class="v-slider carousel #4a148c purple darken-4" data-indicators="true">
      <a class="carousel-item" href="#"><img src="/images/image1.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image2.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image3.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image4.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image5.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image6.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image1.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image2.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image3.jpg"></a>
      <a class="carousel-item" href="#"><img src="/images/image4.jpg"></a>
    </div>
  `,

  created() {
    console.log("slider created");
    $(document).ready(function(){
      $('.carousel').carousel();
    });
  }
});

// #cfd8dc blue-grey lighten-4
var v_contact_info = Vue.component("v-contact-info", {
  template: `
    <div class="v-contact-info row">
      <h5>Contact info</h5>
      <p>
        gummybears
      </p>
      <p>
        1018 WM Amsterdam
      </p>
      <p>
        Telephone: +31 (0) 633101066
      </p>
      <p>
        E-mail: info@gummybears.nl
      </p>
    </div>
  `,
});

 // #cfd8dc blue-grey lighten-4
//      <h5>Contact form</h5>
var v_contact_form = Vue.component("v-contact-form", {
  data() {
    return {
      name     : "",
      email    : "",
      phone    : "",
      website  : "",
      message  : "",
      errors   : new Errors(),
    }
  },
  template: `
    <div class="v-contact-form">
      <div class="row">
        <h5>Feel free to send us your comments</h5>
        <form method="POST" action="/api/v01/contact" class="col s12" @submit.prevent="onSubmit" @keydown="errors.clear($event.target.name)">
          <div class="row">
            <div class="input-field col s4">
              <label for="name">Name</label>
              <input id="name" name="name" type="text" class="validate" v-model="name">
            </div>

            <div class="input-field col s4">
              <label for="email">Email</label>
              <input id="email" name="email" type="text" class="validate" v-model="email">
            </div>

            <div class="input-field col s4">
              <label for="phone">Phone</label>
              <input id="phone" name="phone" type="text" class="validate" v-model="phone">
            </div>
          </div>
          <div class="row">
            <div class="input-field col s12">
              <label for="website">Website</label>
              <input id="website" name="website" type="text" class="validate" v-model="website">
            </div>
          </div>

          <div class="row">
            <div class="input-field col s12">
              <label for="message">Message</label>
              <input id="message" name="message" type="text" class="validate" v-model="message">
            </div>
          </div>

          <div class="row">
            <div class="col s12">
              <button type="submit" :disabled="errors.any()" class="waves-effect waves-light btn red darken-4">Send</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  `,
  methods : {
    onSubmit() {
      console.log("contact form submit clicked");
      // // get the current object
      // var that = this;
      //
      // // post ticket
      // axios.post('/api/v01/tickets', this.$data)
      // .then(function (response) {
      //
      //
      // })
      // .catch(function (error) {
      //   that.errors = new Errors(error.response.data);
      // });
    },
  },

});

// #cfd8dc blue-grey lighten-4
//        <h4>Contacts</h4>
var v_contact = Vue.component("v-contact", {
  template: `
    <div class="v-contact">
      <div class="container">
        <div class="row">
          <v-contact-info class="col s4"></v-contact-info>
          <div class="col s1"></div>
          <v-contact-form class="col s4"></v-contact-form>
        </div>
      </div>
    </div>
  `,
});

 // #cfd8dc blue-grey lighten-4
var v_download_form = Vue.component("v-download-form", {
  data() {
    return {
      name     : "",
      email    : "",
      errors   : new Errors(),
    }
  },
  template: `
    <div class="v-download-form">
      <div class="row">
        <form method="POST" action="/api/v01/download" class="col s12" @submit.prevent="onSubmit" @keydown="errors.clear($event.target.name)">
          <div class="row">
            <div class="input-field col s8">
              <label for="name">Name</label>
              <input id="name" name="name" type="text" class="validate" v-model="name">
            </div>
          </div>

          <div class="row">
            <div class="input-field col s8">
              <label for="email">Email</label>
              <input id="email" name="email" type="text" class="validate" v-model="email">
            </div>
          </div>

          <div class="row">
            <div class="col s12">
              <button type="submit" :disabled="errors.any()" class="waves-effect waves-light btn red darken-4">Send</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  `,
  methods : {
    onSubmit() {
      console.log("download form submit clicked");
      // // get the current object
      // var that = this;
      //
      // // post ticket
      // axios.post('/api/v01/tickets', this.$data)
      // .then(function (response) {
      //
      //
      // })
      // .catch(function (error) {
      //   that.errors = new Errors(error.response.data);
      // });
    },
  },

});

// #cfd8dc blue-grey lighten-4
var v_download = Vue.component("v-download", {

  template: `
    <div class="v-download">
      <div class="container">
        <h5>Please fill out the form</h5>
        <h6>You will receive an email with a download link</h6>
        <div class="row">
          <v-download-form class="col s4"></v-download-form>
        </div>
      </div>
    </div>
  `,
});

//  #cfd8dc blue-grey lighten-4"
var v_forum_form = Vue.component("v-forum-form", {
  data() {
    return {
      username : "",
      password : "",
      errors   : new Errors(),
    }
  },
  template: `
    <div class="v-forum-form">
      <div class="row">
        <form method="POST" action="/api/v01/forum/login" class="col s12" @submit.prevent="onSubmit" @keydown="errors.clear($event.target.name)">
          <div class="row">
            <div class="input-field col s8">
              <label for="name">Username/Email</label>
              <input id="name" name="username" type="text" class="validate" v-model="username">
            </div>
          </div>

          <div class="row">
            <div class="input-field col s8">
              <label for="password">Password</label>
              <input id="password" name="password" type="password" class="validate" v-model="password">
            </div>
          </div>

          <div class="row">
            <div class="col s4">
              <button type="submit" :disabled="errors.any()" class="waves-effect waves-light btn red darken-4">Login</button>
            </div>
          </div>
        </form>
      </div>
    </div>
    </div>
  `,
});

// #cfd8dc blue-grey lighten-4">
var v_forum = Vue.component("v-forum", {
  props : ['color'],
  template: `
    <div class="v-forum" :class="color">
      <div class="container">
        <h4>Forum</h4>
        <div class="row">
          <v-forum-form class="col s4"></v-forum-form>
        </div>
      </div>
    </div>
  `,
});

var v_feature = Vue.component("v-feature", {
  props : ['p_source','p_title','p_text', 'p_class'],
  template: `
    <div class="v-feature col" :class="p_class">
      <img :src="p_source"/>
      <h4>{{p_title}}</h4>
      <p>{{p_text}}</p>
    </div>
  `,
});


// <v-feature p_source="/images/lock-white.png" p_title="Secure by default"   p_text="Hello" ></v-feature>
//:ref="features"
var v_features = Vue.component("v-features", {
  data : function(){
    return {
      ref: "",
    }
  },
  template: `
    <div class="v-features #eeeeee grey lighten-3">
      <div class="container">
        <div class="row">
          <v-feature p_class="s4" p_source="/images/box-white.png"  p_title="No dependencies"     p_text="Written in Go, GoAsy binary is entirely self-contained" ></v-feature>
          <v-feature p_class="s4" p_source="/images/pillow-white.png" p_title="Easy on beginners" p_text="Both for developers and professionals" ></v-feature>
          <v-feature p_class="s4" p_source="/images/stack-white.png" p_title="Production ready"   p_text="All GoAsy elements are tested and fully documented" ></v-feature>
        </div>
      </div>
    </div>
  `,
});

var v_main = Vue.component("v-main", {
  data: function () {
    return {
      errors : new Errors(),
    }
  },

  template: `
    <div class="v-main">
      <v-slider></v-slider>
      <v-features></v-features>
    </div>
  `,
});


const known_routes = [
  { path: '/',         meta: {title: "gummybears | Home"},     component: v_main },
  { path: '/features', meta: {title: "gummybears | Features"}, component: v_main },
  { path: '/contact',  meta: {title: "gummybears | Contact"},  component: v_contact },
  { path: '/download', meta: {title: "gummybears | Download"}, component: v_download },
  { path: '/forum',    meta: {title: "gummybears | Forum"},    component: v_forum },
]

const router = new VueRouter({
  //mode: 'history',
  routes: known_routes,
  linkActiveClass: 'is-active',
})

// to set the document title when we change routes
router.beforeEach((to, from, next) => {
  document.title = to.meta.title
  next()
})

var vm0 = new Vue({
  el: '#app',
  router,
})
