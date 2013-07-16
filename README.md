This is the source for aurajs.com website.

It's a [middleman](http://middlemanapp.com/) app. 

## Running locally 

```
bundle install
middleman
```

## Building for release

### Regenrating jsdoc from aurajs/aura

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


