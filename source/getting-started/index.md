---
title: Getting Started
subtitle: A framework-agnostic, extensible architecture for decoupled and reusable components.
markdown_navigation: true
---

# Concepts

## Aura App

Your application will be an instance of the `Aura` object.

It is responsible for loading extensions when the app starts and cleaning them up when the app stops.

## Extension

Extensions are loaded in your application when it starts. They allow you to add features to the application, and are available to the components through their `sandbox`.

## Core

The `core` implements aliases for DOM manipulation, templating and other lower-level utilities that pipe back to a library of choice. Aliases allow switching libraries with minimum impact on your application.

## Sandbox

A `sandbox` is just a way to implement the [facade](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#facadepatternjavascript) pattern on top of features provided by `core`. It lets you expose the parts of a JavaScript library that are safe to use instead of exposing the entire API. This is particularly useful when working in teams.

When your app starts, it will create an instance of `sandbox` in each of your components.

## Component

A component represents a unit of a page. Each component is independent.
This means that they know nothing about each other. To make them communicate, a [Publish/Subscribe (Mediator)](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#mediatorpatternjavascript) pattern is used.


# Components

The simplest usable Aura application using a component and extension can be found in our [boilerplate](https://github.com/aurajs/boilerplate) repo. We do, however, recommend reading the rest of the getting started guide below to get acquainted with the general workflow.


## Creating and starting an application

The first step in creating an Aura application is to make an instance of `Aura`.

```js
require(['aura'], function(Aura) {
  var app = new Aura();
});
```

Now that we have our `app`, we can start it.

```js
app.start();
```

This starts the `app` by saying that it should search for components anywhere in the `body` of your HTML document.

If you want to restrict to scope to your application to a particular element, or set of elements in your document, you can pass a selector to start:

```js
app.start('#container');
```

### App configuration

Aura's constructor can take a configuration object, that will be available as `app.config` in the extensions.

Currently, the only config entry available on a barebone Aura application is `debug` (cf. [debug section](#debugging))


## Creating a component

By default components are loaded from `./aura_components`, relative to your current document.

Let's say we want to create a "hello" component. To do that we need to create a `aura_components/hello` directory

This directory must contain:

- A `main.js` file. It will bootstrap and describe the component. It is mandatory, no matter how small it is.
- All the other files that your component needs (models, templates, …).

For our "hello" component the `main.js` will be:

__aura_components/hello/main.js__

```js
define({
  initialize: function () {
    this.$el.html('<h1>Hello Aura</h1>');
  }
});
```

On start, Aura will call the `initialize` method for each component instance.

## Starting components

### Using markup

By default, your application will look for DOM Elements with a `data-aura-component` attribute.

Example:

```html
<div data-aura-component="hello"></div>
```

Just include them in your page, and Aura will bring them to life automatically on start.

You can also pass options to your component via data-attributes.

Example:

```html
<div data-aura-component="hello"
      data-aura-foo="bar"
      data-aura-other-option="hello again"></div>
```

They will then be available in your component instance as:

```js
this.options.foo          // -> bar
this.options.otherOption  // -> hello again
```

### "Manually"

The other way to start components on application start is to explicitly pass a list to the `app.start` method.

example:

```js
app.start([{ name: 'hello', options: { el: '#hello' } }]);
```

All listed components MUST have at least the `name` and `options.el` defined, where `name` is the name of the component to start and `options.el` is a DOM selector to target the DOM Element that will be the root of your component.

All other values passed to the options object, will be available in your component in `this.options`.

## Nesting components

This really starts to get interesting if you use templating and use Aura's superpower to nest components.

Let's take an example (using underscore templating):

__aura_components/parent/template.html__

```html
<ul>
  <% _.each(children, function(child) { %>
  <li data-aura-component='child' data-aura-my-name='<%= child.name %>'></li>
  <% }); %>
</ul>
```

__aura_components/parent/main.js__

```js
define(['text!./template.html'], function(tpl) {
  var template = _.template(tpl);
  return {
    initialize: function() {
      var children = this.options.children.split(",");
      this.html(template({ children: children }));
    }
  }
});
```

__aura_components/child/main.js__

```js
define({
  initialize: function() {
    this.html("I am " + this.options.myName);
  }
});
```

Then if you include your `parent` component:

```html
<div data-aura-component="parent" data-aura-children="one,two,three"></div>
```

The result will be:

```html
<div data-aura-component="parent" data-aura-children="one,two,three">
  <ul>
    <li data-aura-component='child' data-aura-my-name='one'>I am one</li>
    <li data-aura-component='child' data-aura-my-name='two'>I am two</li>
    <li data-aura-component='child' data-aura-my-name='three'>I am three</li>
  </ul>
</div>
```

This means that you can truly build your applications one component at a time and literally assemble them with markup.


### Nesting "manually"

Components can also start children via their `this.sandbox.start` method, which can, like the `app.start` method, start nested components by passing a list of component descriptions.

Example:

__aura_components/my_component/main.js__

```js
define({
  initialize: function() {
    this.$el.html("<div id='a-child-component'></div>");
    this.sandbox.start([{ name: 'child', options: { el: '#a-child-component' }}]);
  }
})
```

The `this.html` method actually does just that and this would be the exact equivalent of doing:

```js
define({
  initialize: function() {
    this.html("<div data-aura-component='child'></div>");
  }
})
```

## Communication between components

The Aura [Mediator](https://github.com/aurajs/aura/blob/master/lib/ext/mediator.js) allows components to communicate with each other by subscribing, unsubscribing and emitting sandboxed event notifications. The signatures for these four methods are:

* `sandbox.on(name, listener, context)`
* `sandbox.once(name, listener, context)`
* `sandbox.off(name, listener)`
* `sandbox.emit(data)`

Below we can see an example of a component from our TodoMVC example using the Mediator to emit a notification when tasks have been cleared and subscribing to changes from `tasks.stats` in order to render when they are updated.

```js
define(['hbs!./stats'], function(template) {
  return {
    initialize: function() {
      this.sandbox.on('tasks.stats', this.render, this);
    },
    render: function(stats) {
      this.html(template(stats || {}));
      this.$el.find('button').on('click', _.bind(this.clearCompleted, this));
    },
    clearCompleted: function() {
      this.sandbox.emit('tasks.clear');
    }
  }
});
```

## Component sources

Aura comes with the awesome ability to load components on demand from different sources.
A "component source" is just a http endpoint that serves components. It can be hosted anywhere on the web!

Aura comes preconfigured with one 'source' called 'default', which corresponds to `./aura_components` (relative to the current document).

This can be overridden through your app's config like this:

```js
aura({
  sources: { default: '/path/to/my/components' }
}).start();
```

or even:

```js
aura({
  sources: { default: 'https://another.doma.in/path/to/my/components' }
}).start();
```

You can add other sources in this `config.sources` object.

Let's say that we have a source for GitHub components:

```js
aura({
  sources: {
    github: 'https://another.doma.in/path/to/my/github/components'
  }
}).start();
```

You can then reference and load them by appending @[source] after them. For the 'default' source, this is optional.

For example, if under our 'github' source, we have an `issues` component and a `user-profile` component under our 'default' source:

```html
<div data-aura-component='issues@github' data-aura-repo='aurajs/aura'></div>
<div data-aura-component='user-profile' data-aura-user='addyosmani'></div>
```

The equivalent in javascript would be:

__aura_components/my-component/main.js__

```js
define({
  initialize: function() {
    var markup = "<div id='issues'></div><div id='user-profile'></div>";
    this.$el.html(markup);
    this.sandbox.start([
      { name: 'issues@github', options: { el: '#issues', repo: 'aurajs/aura' } },
      { name: 'user-profile', options: { el: '#user-profile', user: 'addyosmani' } }
    ]);
  }
});
```

# Extending Aura

So far our components can render markup and bring children to life, but that's probably not enough.

We could teach them how to load templates easily or talk to GitHub's API.

Let's get to the basics first:

Extensions are loaded and run when the application starts. It means that Aura guarantees that when your first component is loaded, all the extensions have already been loaded.

All extensions have access to the internals of your app, and can do pretty much what they want at this stage, but they are really only supposed to provide features to the components via the `sandbox` object, available on the app's instance.

This `sandbox` is like a blueprint that gets augmented by the extensions during the app initialization process. Afterwards, each component will get a new fresh clone of this object.

This instance of `sandbox`, available via `this.sandbox` inside our component, is the ONLY thing it knows about the outside world.

## Creating extensions

Imagine that we need a helper to reverse a string. In order to accomplish that and make it available to your components, let's create a very simple extension:

__aura_extensions/reverse.js__

```js
define({
  initialize: function (app) {
    app.sandbox.reverse = function (string) {
      return string.split('').reverse().join('');
    };
  }
});
```

Then to use it within a component:

```js
define({
  initialize: function() {
    var reversed = this.sandbox.reverse("reverse me");
    this.html(reversed);
  }
});
```

## Extensions formats


### Function

```js
var ext = function(app) {
  app.core.hello = function() {  alert("Hello World") };
}
aura().use(ext).start('body');
````

### Object literal

```js
aura().use({
  require: {
    paths: {
      my_module: 'bower_components/my_module'
    }
  },
  initialize: function(app) {
    var MyModule = require('my_module');
    app.core.hello = function() {  alert("Hello World") };
  },
  afterAppStart: function() {
    console.warn("My Aura App is now started !");
  }
}).start('body');
````

The object literal form allows you to add AMD dependencies and application lifecycle callbacks like `afterAppStart`.


## "requiring" AMD modules

Extensions can be defined as AMD module themselves and use the `define([], function() {})` syntax to load dependencies. This is totally fine, but you still need to configure RequireJS (or any other AMD loader) to teach it where to find those dependencies.

We have found that RequireJS central config files can grow pretty dramatically and become hard to manage. It also means that your extensions are not easily portable from one app to the other, since you have to track down all their dependencies and configure Require with the right paths.

We think we have a solution for that. Extensions can define their AMD dependencies, paths, shims and all other AMD config themselves. Combined with sane defaults based on [Bower](https://github.com/bower/bower), we can do things like:

__aura_extensions/my_extension_that_needs_backbone.js__

```js
define({
  require: {
    paths: {
      backbone:   'bower_components/backbone/backbone',
      underscore: 'bower_components/underscore/underscore',
      jquery:     'bower_components/jquery/jquery'
    },
    shim:   { backbone: { exports: 'Backbone', deps: ['underscore', 'jquery'] } }
  },
  initialize: function() {
    var Backbone = require('backbone');
    //... do stuff now ...
  }
});
```

When `initialize` is called, Aura ensures that all the dependencies listed in require.paths are already loaded. So we can use the 'synchonous' require directly.

Actually, what Aura does corresponds to (pseudo-code):

```js
function requireExtension(ext) {
  require.config({ paths: { ... }, shim: { ... } });
  require(['jquery', 'backbone', 'underscore'], function(Backbone, _) {
    $.when(ext.initialize(app)).then( ... load next extension ... );
  })
}
```

_Note. This is not available yet, but in the near future, Aura will provide [grunt](http://gruntjs.com)-based build tools to extract this RequireJS config from your extensions and make it available to the r.js optimizer._


## Dealing with asynchronicity and start process

If your app needs to wait for resources to be loaded (or wait for anything really) before it is able to actually start, the extensions system allows you to do it in one place using Promises.

Let's take, for example, a Facebook extension that wraps and loads the Facebook JavaScript SDK, and provides `auth.login` and `auth.logout` method to our components.

Let's also say that we want to wait for the `facebook.js` library to be loaded and initialized before actually starting our app.

We could do something like:

__aura_extensions/facebook.js__

```js
define({
  require: {
    paths: { facebook: 'http://connect.facebook.net/en_US/all.js' },
    shim:  { facebook: { export: 'FB' } }
  },

  initialize: function(app) {
    var status = app.core.data.deferred();
    app.sandbox.auth = {
      login:  FB.login,
      logout: FB.logout
    };
    FB.init(app.config.facebook);

    FB.getLoginStatus(function(res) {
      app.sandbox.auth.loginStatus = res;
      status.resolve(res);
    }, true);

    return status.promise();
  },

  afterAppStart: function(app) {
    console.warn("The app is started and I am: ", app.sandbox.auth.loginStatus);
  }
});
```

The `initialize` method here returns a [Promise](http://wiki.commonjs.org/wiki/Promises/A). Aura will then automatically wait for the resolution of this promise to actually finish the initialization process.

Actually, when you have multiple extensions, each extension will wait for the resolution of the previous one to call its initialize method.

Each extension can also define an `afterAppStart` method that will be called after the initialization process. Those callbacks will also be called sequentially, keeping the same order as the extensions load order.

## Using extensions

To make our `reverse` helper available in our app, run the following code:

```js
var app = new Aura();
app.use('aura_extensions/reverse');
```

This will call the `initialize` function of our `reverse` extension.

Note: Calling `use` when your app is already started will throw an error.
You CANNOT load extensions after the start method has been called. In fact you SHOULD not even keep a reference to your `app` instance to use it outside of a component.


# Misc

## Debugging

To make `app.logger` available, pass `{ debug: { enable: true } }` or `{ debug: true } into Aura constructor:

```js
var app = new Aura({ debug: { enable: true } });
```

Logger usage:

```js
// You can use logger from components or extensions
var logger = sandbox.logger;

logger.log('Hey');
logger.warn('Hey');
logger.error('Hey');
```

If you want to enable event logging, do this:

```js
  var app = new Aura({ debug: { enable: true }});
```


Also, when the `debug` parameter is true, you can declare following function for any debug purposes:


```js
// Function will be called for all Aura apps in your project
window.attachDebugger = function (app) {
  // Do cool stuff with app object
  console.log(app);

  // Maybe you want to have access to Aura app via developer console?
  window.aura = app;
};
```

## Building Aura

#### Requirements

1. [bower](http://twitter.github.com/bower/): run `npm install -g bower` if needed
2. [grunt-cli](https://github.com/gruntjs/grunt-cli): run `npm install -g grunt-cli` if needed

#### Building Aura.js

1. Run `npm install` to install build dependencies.
2. Run `bower install` to install lib dependencies.
3. Run `grunt build` and `aura.js` will be placed in `dist/`.

### Running Tests

#### Browser

Run `grunt`. Then visit `http://localhost:8899/spec/`.

#### CLI

Run `npm test`.
