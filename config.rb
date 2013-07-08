require "sass-getunicode"

require 'redcarpet'
require 'active_support/core_ext'

Dir['./lib/*'].each { |f| require f }

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :build_dir, "tmp"
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true,
               :gh_blockcode       => true,
               :tables             => true,
               :autolink           => true,
               :smartypants        => true,
               :no_intra_emphasis  => true,
               :pattern            => '```',
               :renderer           => CodeRenderer

# activate :livereload
activate :directory_indexes
activate :markdown_navigation
activate :array_navigation

# page "/extensions*",        layout: 'layouts/default'
page "/",                   layout: 'layouts/default'
page "/getting-started*",   layout: 'layouts/default'
page "/faq*",               layout: 'layouts/default'
page "/api*",               layout: 'layouts/default'
# page "/resources",          layout: 'layouts/default'
page "/examples*",           layout: 'layouts/default'
page "/guides*",            layout: 'layouts/blog'


page "/sitemap.xml", :layout => false

activate :highlighter

activate :api_docs,
  default_class: 'Aura',
  repo_url: 'https://github.com/aurajs/aura'

######
# Blog
######

activate :blog do |blog|
  blog.prefix = 'guides'
  blog.layout = 'layouts/blog'
end

page '/guides/feed.xml', layout: false


################################################################################
# Sass Configuration
################################################################################
require 'lib/retina.rb'
require 'lib/random-color.rb'
Sass::Script::Number.precision = 20

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :cache_buster
  activate :gzip

  set :logging, true
end

# if development?
use RackEnvironment, :file => 'environment.yml' if File.exist?('./environment.yml')
