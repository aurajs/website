require "pathname"
require "active_support/inflector"

module ApiHelpers
  METHOD_ORDER = ["GET", "POST", "PUT", "DELETE"]

  def endpoints
    @endpoints ||= groups.map do |g|
      slug = "endpoint-#{g}"

      ::Middleman::Util.recursively_enhance({
        :name => g.humanize,
        :slug =>  slug,
        :objects => get_objects(g),
        :routes => get_routes(g),
        :introduction => get_introduction(g),
        :objects_slug => "#{slug}-objects",
        :routes_slug => "#{slug}-routes"
      })
    end.sort_by { |e| e[:name] }
  end

  def groups
    Pathname(endpoints_path).children.select { |c| c.directory?  }.map { |d| d.basename.to_s }
  end

  def endpoints_path
    return @endpoints_path unless @endpoints_path.nil?
    @endpoints_path = source_dir + '/docs/api/apis'
    @endpoints_path
  end

  def get_objects(name)
    match_resources("api/apis/#{name}/objects/").map do |o|
      process_objects(o, name)
    end.sort_by { |o| o[:name] }
  end

  def get_routes(name)
    match_resources("api/apis/#{name}/routes/").map do |r|
      process_route(r, name)
    end.sort_by do |r|
      [METHOD_ORDER.index(r[:method]), r[:name]]
    end
  end

  def get_introduction(name)
    resource = sitemap.resources.find do |r|
      r.path.match("api/apis/#{name}/introduction")
    end

    resource.nil? ? "" : resource.render(:layout => false)
  end

  def match_resources(regexp)
    sitemap.resources.select { |r| r.path.match(regexp) }
  end

  def process_objects(resource, prefix = "")
    data = resource.metadata[:page]
    name = data["name"] || Pathname(resource.path).basename(".*").to_s

    ::Middleman::Util.recursively_enhance({
      :name => name.humanize,
      :slug => "#{prefix}-object-#{name}".parameterize,
      :resource => resource.render(:layout => false)
    })
  end

  def process_route(resource, prefix = "")
    data = resource.metadata[:page]
    name = data["name"] || Pathname(resource.path).basename(".*").to_s

    ::Middleman::Util.recursively_enhance({
      :name => name.humanize,
      :slug => "#{prefix}-route-#{name}".parameterize("_"),
      :path => data["path"],
      :method => data["method"],
      :resource => resource.render(:layout => false)
    })
  end
end
