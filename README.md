This repository contains the source for [http://aurajs.com/](http://aurajs.com/) website. Should you be interested in improving our website itself, please feel free. We are accepting pull requests. Get started with instructions below.

Want to hack principal Aura architecure ? Head on [here](https://github.com/aurajs/aura).

## Prerequisites for local setup

* Ruby - Ruby v1.9.3 with [RVM](https://rvm.io/). Download RVM from [here](https://rvm.io/rvm/install).
* [Bundler](http://bundler.io/) - Use ```gem install bundler``` to install it.
* [Middleman](http://middlemanapp.com/) - [http://aurajs.com/](http://aurajs.com/) is a middleman application. Use ```gem install middleman``` to install it.

## Running locally 

```
git clone https://github.com/aurajs/website.git
cd website
bundle install
middleman
```

## Building for release

### Generating jsdoc from aurajs/aura

Checkout aurajs/website and aurajs/aura in the same directory, then run `rake generate_docs`.

### Building and deploying to aurajs/aurajs.github.io

```
git clone git@github.com:aurajs/aurajs.github.io.git build
middleman build
cd build
git add .
git commit -m "Your commit message..."
git push origin master
```
