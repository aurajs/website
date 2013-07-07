require_relative "./code_renderer"

module APIDocs
  class << self
    def repo_url
      @repo_url
    end

    def registered(app, options={})
      app.helpers Helpers

      @repo_url = options[:repo_url]

      app.after_configuration do
        ApiClass.data = data.api
        # Update data caches
        files.changed("data/api.yml") do
          ApiClass.data = data.api
        end
      end
    end
    alias :included :registered
  end

  class ApiClass
    @@cache = {}
    cattr_reader :cache

    @@data = nil
    cattr_reader :data

    def self.data=(value)
      @@cache = {}
      @@data = value
    end

    def self.find(name)
      cache[name] || new(name)
    end

    attr_reader :native

    def initialize(name)
      data = self.class.data['classes'][name]

      if data
        @native = false
        @data = data
      else
        @native = true
        @data = {}
      end
    end

    def to_s
      return self.name
    end

    def extends
      @extends ||= @data['extends'] && self.class.find(@data['extends'])
    end

    def uses
      @uses ||= @data['uses'] ?
                  @data['uses'].map{|u| self.class.find(u) } :
                  []
    end

    def items
      classitems unless @items
      @items
    end

    def classitems
      unless @classitems
        @classitems = {}
        @items = {}

        # Go from root up
        parents = ([extends] + uses.reverse).compact
        parents.each do |parent|
          parent.classitems.each do |type, items|
            items.each do |_, item|
              item = item.clone
              @classitems[item['itemtype']] ||= {}
              existing = @classitems[item['itemtype']][item['name']]
              if existing
                next if existing['class'] == item['class']
                item['overwritten_from'] = existing
              else
                item['extended_from'] = parent
              end
              @items[item['name']] = item
              @classitems[item['itemtype']][item['name']] = item
            end
          end
        end

        self.class.data.classitems.each do |item|
          next if item['class'] != self.name

          item = item.clone
          @classitems[item['itemtype']] ||= {}
          if existing = @classitems[item['itemtype']][item['name']]
            item['overwritten_from'] = existing
          end
          @items[item['name']] = item
          @classitems[item['itemtype']][item['name']] = item
        end
      end

      @classitems
    end

    def [](attr)
      @data[attr]
    end

    def method_missing(method, *args)
      @data[method]
    end
  end

  module Helpers

    def selected_class(key, class_name = nil)
      class_name || 'selected' if current?(key)
    end

    def sha
      data.api.fetch('project')['sha']
    end

    def sha_url
      "#{APIDocs.repo_url}/tree/#{sha}"
    end

    def api_classes
      data.api['classes'].sort
    end

    def api_file_link(item, options = {})
      return unless item['file']
      path = item['file'].sub(/^\.\.\//, '')

      options[:class] ||= 'api-file-link'

      title = path
      link  = "#{APIDocs.repo_url}/tree/#{ApiClass.data['project']['sha']}/#{path}"

      if line = item['line']
        title += ":#{line}"
        link += "#L#{line}"
      end

      title = options.delete(:title) || title

      link_to title, link, options
    end

    def api_class(name)
      return name if name.is_a?(ApiClass)
      name = name['name'] if name.is_a?(Hash)
      ApiClass.find(name)
    end
    alias :api_namespace :api_class

    def api_module_link(name, anchor=nil)
      link = "/api/modules/#{name}.html"
      link += '#'+anchor if anchor
      link_to name, link
    end

    def api_class_link(name, anchor=nil)
      klass = api_class(name)
      if klass && !klass.native
        link = "/api/classes/#{name}.html"
        link += '#'+anchor if anchor
        link_to name, link
      else
        name
      end
    end
    alias :api_namespace_link :api_class_link

    def api_classes_for_item(item)
      classes = [item['access']]
      classes << 'deprecated' if item['deprecated']
      classes << 'inherited' if item['extended_from']
      classes.compact.join(' ')
    end

    def api_classes_for_class(klass)
      api_classes_for_item(api_class(klass))
    end
    alias :api_classes_for_namespace :api_classes_for_class

    def api_markdown(string)
      Redcarpet::Markdown.new(CodeRenderer,
        :layout_engine => :erb,
        :fenced_code_blocks => true,
        :lax_html_blocks => true).render(string)
    end

    def sanitize_class(string)
      string.gsub(/[^a-z0-9_-]+/i, '_');
    end
  end
end

::Middleman::Extensions.register(:api_docs, APIDocs)
