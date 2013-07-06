---
title: Aura Development Docs
date: 2013-07-06 18:13 UTC
tags:
author: sbellity
---

# A new, higher level of abstraction for the web ?

## (re)Introducing AuraJS: an extensible, widget-friendly architecture for building reusable components and apps.

The key word here is reusable. But making reusable stuff is hard, actually it's kind of the Graal of software development.

We've seen a tremendous shift in the javascript community for the past 3 years, with the advent of frameworks like Backbone, AngularJS or Ember. People are starting to make web apps in a much more structured way. MVC pattern, templating engines, JSON APIs are becoming more and more the de-facto standards of these new kind of apps. 

Yet, assembling the bits and pieces and actually starting to make apps is still a challenge. The learning curve is steep and when you pick a framework you are generally more or less stuck in a siloed community.

Another aspect of building web apps nowadays is that most of the time you end up doing the same stuff all over again : you need a way to authenticate users, give them ways to communicate, exchange ideas, work or play together. You have to integrate with external services or APIs like Facebook or Twitter.

Web apps are all about the end user experience, UI, DOM elements. The web development ecosystem is all about much more low level stuff. We need a way to **package higher level abstractions and make them truly reusable**, and that's what AuraJS is all about.

### A higher level of abstraction for the web

Widgets are just that, **complete packaged and reusable pieces of user experience**. You already see them all around the web : Disqus comments, Twitter cards, Facebook social plugins. We all know how easy it is the plug them inside our apps and we should all be able to make stuff like that. 

But it should not stop to widgets for public consumption, we should actually be able to build our apps this way : by assembling / stitching those pieces together. 


### Yet another framework ?

Nope, AuraJS is not another web framework, it's more like an architecture that you can use to structure your apps and make reusable components. AuraJS Widgets can be Backbone, EmberJS or Angular views or even complete apps.

### How does it work ?

Widgets are completely decoupled, they only can talk to each other via events. You can't have a handle on them from the outside, and themselves are just aware of what you explicitely make available throught their `sandboxes`.

To build your app, you can assemble widgets via AuraJS's HTML API, by using the `data-aura-widget` attribute.

Let's take an example. Let's say that we want to build a Github Issues app. We need to be able to :

* Display lists of issues from specific repos
* Filter those issues

Now let's make some widgets, but first we need a way to talk to [Github's API](http://developer.github.com/v3/issues/).

Here is a simple [AuraJS extension](https://github.com/aurajs/aura/blob/master/notes/extensions.md) that does just that :

**extensions/aura-github.js**

    define({
      initialize: function (app) {
        app.sandbox.github = function (path, verb, data) {
          var dfd = $.Deferred();
          var token = app.config.github.token;
          verb = verb || 'get';
          if (data && verb != 'get') {
            data = JSON.stringify(data);
          }
          $.ajax({
            type: verb,
            url: 'https://api.github.com/' + path,
            data: data,
            headers: {
              "Authorization": "token " + token
            },
            success: dfd.resolve,
            error: dfd.reject
          });
          return dfd;
        };
      }
    });

This extension exposes in all our widgets a way to talk to Github's API via the `this.sandbox.github` method.

 To use it in your aura app : 
 
 **app.js**
 
    var app = new Aura({
      github: { token: 'current-user-token-here' }
    });
    app.use('extensions/aura-github');
    app.start({ widgets: 'body' });

And now, let's write the `issues` widget : 

**widgets/issues/main.js**

    define(['underscore', 'text!./issues.html'], function(_, tpl) {
    
      // Allow template to be overriden locally 
      // via a text/template script tag
      var template, customTemplate = $('script['data-aura-template="github/issues"]');
      if (customTemplate.length > 0) {
        template = _.template(customTemplate.html());
      } else {
        template = _.template(tpl);
      }
      
      return {
        initialize: function() {
          _.bindAll(this);
          this.repo   = this.options.repo;
          this.filter = this.options.filter || {};
          this.sandbox.on('issues.filter', this.fetch, this);
          this.fetch();
        },
        fetch: function(filter) {
          this.filter = _.extend(this.filter, filter || {});
          var path = 'repos/' + this.repo + '/issues';
          return this.sandbox.github(path, 'get', this.filter).then(this.render);
        },
        render: function(issues) {
          this.html(template({
            issues: issues,
            filter: this.filter,
            repo: this.repo
          }));
        }
      };
    });


Now we can place this widget everywhere in our app by using Aura's HTML API based on data-attributes.
    
    <div data-aura-widget="issues" data-aura-repo="aurajs/aura"></div>

You can even have multiple instances of this widget in you page : 

    <div class='row'>
      <div class='span4' data-aura-widget="issues" data-aura-repo="aurajs/aura"></div>
      <div class='span4' data-aura-widget="issues" data-aura-repo="emberjs/ember.js"></div>
      <div class='span4' data-aura-widget="issues" data-aura-repo="documentcloud/backbone"></div>
    </div>

Any other widget can now emit `issues.filter`  events that these widgets will respond to.
For example in another widget that will allow the user to filter the issues lists, we can have : 

    this.sandbox.emit('issues.filter', { state: 'closed' });

You can find a [Github client demo app based on AuraJS + a bunch of Github widgets here](http://github.com/sbellity/aura-github).

### Building an ecosystem

Now that we have this `aura-github` extension and these widgets, we can distribute them easily (either via package managers like [Bower](http://twitter.github.com/bower/) or by publishing an AuraJS `WidgetSource` and anyone can start assembling Github Apps just by inserting `data-aura-widget` powered elements in their markup.

AuraJS in itself is a pretty small library but it's been lovingly designed to be the basis of an ecosystem.
Everyone can now start creating and publishing extensions and widgets that should be ready to use. We even added a pretty powerful feature : the ability to created `WidgetSources` : basically, it allows anyone to publish a collection of ready to use widgets somewhere on the web. 

To use this, just declare your source in your app's config :

    var app = Aura({ 
      github: { token: 'current-user-token' },
      widgets: { 
        sources: { 
          github: 'https://path.to/github/widgets',
          default: '/widgets'
        }
      }
    });
    app.use('http://path.to/github/extensions/aura-github');
    app.start({ widgets: 'body' });

Then you can start using github powered widgets in your app : 

    <div data-aura-widget="issues@github" data-aura-repo="aurajs/aura"></div>

Note the `@github` appended to the widget name ? It's there to tell you app to use the `issues` widget from the `github` `WidgetSource`.
Just drop the `@xxx` suffix to use widgets defined as the `default` source. 

### Hull ♥ AuraJS

How do we use AuraJS at Hull ?

Basically, [HullJs](http://hull.io/docs/Hull.js/introduction/), our client side javascript library, is just and AuraJS app with a bunch of extensions, and a collection of [packaged, ready to use widgets](http://hull.io/docs/widgets/packaged_widgets/) that are configured to talk to [our APIs](http://hull.io/docs/api/introduction/).


### What's next ?

This is just an introduction and there is much more to it ;) 
We are currently in the process of writing a more extensive documentation with the [AuraJS team](https://github.com/aurajs/aura/contributors) and a collection of extensions to integrate easily with other libraries / frameworks and services.

A few additional stuff we are investigating : 

* [Web components](http://html5-demos.appspot.com/static/webcomponents/index.html). We think AuraJS Widgets are a great fit to start working with web components. We'll start experimenting with them soon.
* [postal.js](https://github.com/postaljs). Currently, AursJS mediator is implemented with [EventEmitter2](https://github.com/hij1nx/EventEmitter2), but postal's extensible architecture would allow us to have apps that could communicate seamlessly [accross frames or windows](https://github.com/postaljs/postal.xframe) or even [accross the web via WebSockets](https://github.com/postaljs/postal.socket)
* Extensions to make it easy to write Backbone, EmberJS or Angular powered widgets. 


What do you think ? We'd love to have your feedback.
