---
title: Requirements
subtitle: What is needed to run an Aura app ?
markdown_navigation: true
---

## What does Aura rely on ?

- A Promise/A implementation
- and AMD loader
- a small subset of underscore (because coding without it sucks)
- an eventemitter implementation
- a selector engine

As per the current version, the following implementations are provided with Aura:

- **Promise/A**: [jQuery Deferred](http://api.jquery.com/jQuery.Deferred/), but [Q](https://github.com/kriskowal/q) and [rsvp.js](https://github.com/tildeio/rsvp.js) are great options.
- **AMD**: [requirejs](http://requirejs.org), but it would be nice to test other ones (curl.js for example which is much smaller).
- **underscore**: we could make a minimal build of [lodash](http://lodash.org) and distribute it with aura.
- **eventemitter**: [eventEmitter2](https://github.com/hij1nx/EventEmitter2), for the moment. we could also have a look at [postal.js](https://github.com/postaljs/postal.js) which is extensible and may suit more our needs.
- **selector engine**: Currently [jQuery](http://jquery.com) required by the components extension, which is always included for the moment. but we don't really have to.

## Is there a minimum browser requirement for Aura? A recommended browser/cpu requirement?

It should work everywhere. Aura itself is really tiny !
Although we recommend to use the latest possible browser for yout computer, you'll always get a better experience.

We should have a way to CI on several browsers...

- [Karma](http://karma-runner.github.io/0.8/index.html)
- [http://yeti.cx/](http://yeti.cx)
- [https://npmjs.org/package/bunyip](https://npmjs.org/package/bunyip)
- [https://npmjs.org/package/browserstack](https://npmjs.org/package/browserstack)

## Does aura have a core functionality or extension to see if a browser can utilitize something, like hasjs? is this a potential extension idea?

Not yet, but it would definitely be nice to have.
For the moment the `platform.js` file is a collection of polyfills for older browsers, but it does not really scale...

Including more featureful polyfills like [es5-shim](https://github.com/kriskowal/es5-shim) is a possibility but the goal was to keep Aura as small as possible.

