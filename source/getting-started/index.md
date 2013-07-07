---
title: Getting Started
markdown_navigation: true
---

## Concepts

### The `Aura` object

Your application will be an instance of the `Aura` object.

Its responsibilities are to load extensions when the app starts and clean them up when the app stops.

### Extension

Extensions are loaded in your application when it starts. They allow you to add features to the application, and are available to the components through their `sandbox`.

### Core

The `core` implements aliases for DOM manipulation, templating and other lower-level utilities that pipe back to a library of choice. Aliases allow switching libraries with minimum impact on your application.

### Sandbox

A `sandbox` is just a way to implement the [facade](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#facadepatternjavascript) pattern on top of features provided by `core`. It lets you expose the parts of a JavaScript library that are safe to use instead of exposing the entire API. This is particularly useful when working in teams.

When your app starts, it will create an instance of `sandbox` in each of your components.

### Component

A component represents a unit of a page. Each component is independent.
This means that they know nothing about each other. To make them communicate, a [Publish/Subscribe (Mediator)](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#mediatorpatternjavascript) pattern is used.


## Getting started

The simplest usable Aura app using a component and extension can be found in our [boilerplate](https://github.com/aurajs/boilerplate) repo. We do however recommend reading the rest of the getting started guide below to get acquainted with the general workflow.


### Creating an Application

The first step in creating an Aura application is to make an instance of `Aura`.

```js
var app = new Aura();
```

Now that we have our `app`, we can start it.

```js
app.start({
  component: 'body'
});
```

This starts the app by saying that it should search for components anywhere in the `body` of your HTML document.

### Creating a Component

By default components are retrieved from a directory called `/aura_components` that must be at the root level of your app.

Let's say we want to create an "hello" component. To do that we need to create a `aura_components/hello` directory

This directory must contain:

- A `main.js` file. It will bootstrap and describe the component. It is mandatory, no matter how small it can be.
- All the other files that your component needs (models, templates, …).

For our "hello" component the `main.js` will be:

```js
    define({
      initialize: function () {
        this.$el.html('<h1>Hello Aura</h1>');
      }
    });
```

### Declaring a Component

Add the following code to your HTML document.


```html
<div data-aura-component="hello"></div>
```

Aura will call the `initialize` method that we have defined in `aura_components/hello/main.js`.

## Extending Aura

### Creating extensions

Imagine that we need an helper to reverse a string. In order to accomplish that and make it available to your Components, we'll need to create an extension.

```js
define('extensions/reverse', {
  initialize: function (app) {
    app.sandbox.util.reverse = function (string) {
      return string.split('').reverse().join('');
    };
  }
});
```

Then to use it within a Component : 

```js
define({
  initialize: function() {
    var reversed = this.sandbox.util.reverse("reverse me");
    this.$el.html(reversed);
  }
});
```

### Using extensions

To make our `reverse` helper available in our app, run the following code:

```js
var app = new Aura();
app.use('extensions/reverse');
```

This will call the `initialize` function of our `reverse` extension.

Note: Calling `use` when your `app` is already started will throw an error.


## Event notifications

The Aura [Mediator](https://github.com/aurajs/aura/blob/master/lib/ext/mediator.js) allows Components to communicate with each other by subscribing, unsubscribing and emitting sandboxed event notifications. The signatures for these three methods are:

* `sandbox.on(name, listener, context)`
* `sandbox.off(name, listener)`
* `sandbox.emit(data)`

Below we can see an example of a Backbone view using the Mediator to emit a notification when tasks have been cleared and subscribing to changes from `tasks.stats` in order to render when they are updated.

```js
define(['hbs!./stats'], function(template) {
  return {
    type: 'Backbone',
    events: {
      'click button': 'clearCompleted'
    },
    initialize: function() {
      this.render();
      this.sandbox.on('tasks.stats', _.bind(this.render, this));
    },
    render: function(stats) {
      this.html(template(stats || {}));
    },
    clearCompleted: function() {
      this.sandbox.emit('tasks.clear');
    }
  }
});
```



## Debugging

To make `app.logger` available, pass `{debug: true}` into Aura constructor:

```js
var app = new Aura({ debug: true });
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
  var app = new Aura({debug: true, logEvents: true});
```


Also, when parameter `debug` is true, you can declare following function for any debug purposes:


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
