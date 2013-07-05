# Hull's Website.

Quite simply, our public website.
Now it uses [Middleman](http://middlemanapp.com/)

## Recommended setup :

* [Chrome](https://www.google.com/intl/en/chrome/browser/)
* [Livereload Chrome extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)
* [Sublime Text](http://www.sublimetext.com/)
  - [Package Control](http://wbond.net/sublime_packages/package_control)
  - [Guard package](https://github.com/cyphactor/sublime_guard)
  - [Slim package](https://github.com/fredwu/ruby-slim-tmbundle)
  - [Compass/Sass package](https://github.com/kuroir/Sublime-Compass)

## Usage :

### LiveReload
ensure your browser has the extension installed.

    `guard start` for Livereload

### Icon Fonts :
http://fontcustom.com

One Shot :

    fontcustom compile source/images/icons/ -o source/stylesheets/ -t scss -h false

Watcher :

    fontcustom watch source/images/icons/ -o source/stylesheets/ -t scss -h false

Heroku : 
    heroku config:add BUILDPACK_URL=http://github.com/indirect/heroku-buildpack-middleman.git --app hullio-dev

## Documentation guidelines

Following these guidelines helps to write a understandable documentation.

* Please **do not** add any ``<h1>``


### Example:
	
		Short and descriptive introduction to the current section.

    ## First level
    
    Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsum cupiditate facere rerum tenetur nesciunt maxime.
    
    * ``param``: definition ipsum dolor sit amet
    * ``param``: definition ipsum dolor sit amet
    * ``param``: definition ipsum dolor sit amet
    * ``param``: definition ipsum dolor sit amet
    
    ### Second level of title
    
    Code Example:
    
    <pre class='language-javascript'><code>Hull.widget('awesome', {
      datasources: {},
      templates: [],
      initialize: function () {},
      beforeRender: function (data) {},
      afterRender: function () {},
      /* append your own component methods */
    });</code></pre>
