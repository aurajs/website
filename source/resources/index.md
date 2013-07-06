---
title: Aura
subtitle: A framework-agnostic architecture for decoupled reusable components.
markdown_navigation: true
---

# Resources

## Yeoman generator

An Aura scaffolding generator (for Yeoman) is also available at [Aura generator](https://github.com/dotCypress/generator-aura).

### Usage

```bash
  # First make a new directory, and `cd` into it:
  mkdir my-awesome-project && cd $_

  # Then install `generator-aura`:
  npm install -g generator-aura

  # Run `yo aura`, optionally passing an app name:
  yo aura [app-name]

  # Finally, install npm and bower dependencies:
  npm install && bower install --dev
```

### Generators

Available generators:

* [aura:component](#component)
* [aura:extension](#extension)
* [aura:styles](#styles)

### Component
Generates a component in `app/components`.

Example:

```bash
yo aura:component sample
```

Produces `app/components/sample/main.js`

### Extension
Generates a extension in `app/extensions`.

Example:
```bash
yo aura:extension storage
```

Produces `app/extensions/storage.js`

### Styles
Generates cool styles.

Example:
```bash
yo aura:styles
```

##### Supported types:

* Default (normalize.css)
* Twitter Bootstrap
* Twitter Bootstrap for Compass
* Zurb Foundation