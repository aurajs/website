---
title: Extensions
markdown_navigation: true
---

## Aura Core extensions

### Debug

debug extension to provide feedback to the developers.
if app.config.debug = true then debug is activated.

- what tools are here? loggers? read eval print loop?
- are they cross-browser compatible? to what version?

For the moment... nothing much here, but we should provide strong debugging tools
here


### Mediator

App pubsub / mediator pattern. Provides a central point of communication... blablabla

- this is the pubsub?

yep, very minimal for the moment too...
came accross postal.js which seems an interesting candidate to replace ee2 (smaller, more modular...).

An other idea to have a rich api on top of the mediator, would be to have a middleware stack around it
It would allow us to implement the permissions system as a middleware for example.


- can does mediator handle any other functionality other than pubsub?

### Components

Components features...

