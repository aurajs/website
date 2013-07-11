---
title: FAQs
subtitle: In progress...
markdown_navigation: true
---

## Why Aura?

Web apps are all about the end user experience (UI, DOM elements). The web development ecosystem is all about much more low level stuff. We need a way to package higher level abstractions and make them truly reusable, and that's what Aura is all about.

Need some more reasons to use Aura? Let's name a few:

* It's basically **glue** for your application components, making it trivial to tie together a number of independently created components into a fully functional application.
* A complete event-bus supporting **application-level and component-level communication** mean you have control over what is getting triggered in your app
* Specify an API end-point for components easily and just **use data-attributes to include any component** or components. Minimal JavaScript for more capabilities.
* **Abstract away utility libraries** you are using (templating, DOM manipulation) so that you can swap them out for alternatives at any time without a great deal of effort
* Hit the ground running quickly components into **reusable modules using AMD**.
* Bower is a first-class citizen in Aura, making it easier to **manage your application dependencies**
* The web platform is moving towards using scoped styles and shadow DOM for keeping parts of your page safe from third-party content that might affect it. Aura does the same for communications by introducing per-component **sandboxes** for your events
* Tooling for **scaffolding** out new components without having to write as much boilerplate
* Can be used with your MVC framework of choice - we're just there as a helper.
* First-class support for the Hull.io platform. If you don't want to create a component yourself, you can easily use them as a component-source and create apps in less time.
* Extensible via the extensions system, which make a good basis for a rich ecosystem around the project.

## In Discussion(s)

* [Where does Aura fit in the MVC workflow?](https://github.com/aurajs/aura/issues/223)
* [How do you initialize a component with data objects?](https://github.com/aurajs/aura/issues/222)
* [Using multiple views and models in a component](https://github.com/aurajs/aura/issues/224)
* [Sharing collections of data](https://github.com/karlwestin/aura-example)


## Why do developers use us?

* "The architecture and the fact that Aura Components are completely decoupled, will allow us to build an ecosystem of components that people can reuse internally or share with others."
* "With ComponentSources and Require, we can load only the components that are needed by the app... at runtime."
* "No JS is required to wire everything up, just include components with data-attributes in their markup"
* "Mediation, same thing here it's a prerequisite to make everything decoupled... but in addition, it allows us to write much less code..."
* "Template overrides FTW"


## Other...

* How does Aura recommend I share data between multiple components?

* Aura was originally tightly coupled with Backbone. Can it now be used with any framework and just how easy is this to setup?

* What does the Aura footprint look like? I like everything I get with it, but how much more code is it likely to introduce to my production application?

* Aura extensions appear to be custom wrappers around a framework. What is the benefit of this and does it need to be done for each framework or library I want to use?

* If I use Aura do I need to also use RequireJS? What if I don’t like AMD or prefer using CommonJS?

* Backbone developers generally end up having to write their own architecture on top of it or using an extension architecture like Marionette. Does Aura work well with Marionette or other Backbone libraries?

* Are Aura apps crawlable? If not, do you recommend using any specific third-party tool for helping make them crawlable? (e.g Rendr)

* How easy is it to debug an application built using Aura?

* Aura appears to be a little similar to Flight by Twitter. What are the main differences between them and why or where should I use Aura instead of flight?

* Your docs mention that you intend to use Web Components and Polymer under the sheets eventually. Is there a timeline for this at present?

* Aura considers Bower a first-class citizen when working with it. What if I prefer to work with NPM and browserify. Can I still use Aura without worrying about package managers?

* Hull.io appears to be based around Aura. How do they differ and what do developers gain from using Hull as a platform if they so choose it?

* How does Aura solve the problem of nesting components? If I were to have one component inside of another, would it just work or would I need to go to extra lengths to get this working? 

* How do you recommend packaging and sharing Aura components with other developers?
