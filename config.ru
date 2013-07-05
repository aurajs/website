require 'rack'
require 'rack/contrib/try_static'

use Rack::TryStatic, :root => "tmp", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

run lambda{ |env|
  not_found_page = File.expand_path("../tmp/404/index.html", __FILE__)
  if File.exist?(not_found_page)
    [ 404, { 'Content-Type'  => 'text/html'}, [File.read(not_found_page)] ]
  else
    [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ]
  end
}
