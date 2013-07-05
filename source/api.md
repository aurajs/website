---
title: Reference API
subtitle: A framework-agnostic architecture for decoupled reusable components.
markdown_navigation: true
---

# App

An App is the entry point to the wonderful world of Aura.
To create one, you just have to invoke Aura's main constructor and pass pass an optional config object then start it.

    require(['aura'], function(aura) {
      var config = { ... };
      aura(config).start('body');
    });


## aura(config)


### Parameters:
  
* config (Object)

Aura App config. accessible via `app.config`.

### Returns:

An Aura App instance.

## app.use(extention)

#### Parameters:

* extension (String|Function|Object)


## app.start

## app.stop

## app.createSandbox


# Core

## core.addComponentsCallback

## core.addComponentsSource

## core.mediator

# Sandbox

## sandbox.start

## sandbox.stop

## sandbox.on

## sandbox.off

## sandbox.emit

## sandbox.stopListening

# Component

## this.initialize

## this.html

# Base

## base.util

## base.dom

## base.data
