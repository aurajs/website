require "slim"
require "sass-getunicode"
require "./lib/markdown_navigation"
require "./lib/array_navigation"

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
               :pattern            => '```'

activate :livereload
activate :directory_indexes
activate :markdown_navigation
activate :array_navigation

page "/*", :layout => :default, :page_type=>'docs'
page "/sitemap.xml", :layout => false

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
