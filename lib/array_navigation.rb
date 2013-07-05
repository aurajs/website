require "active_support/inflector"

module ArrayNavigation
  class NavigationElt
    def initialize(d)
      if (d.is_a?(String))
        @title = d.humanize.titleize
        @component = d
        @children = []
      else
        @children = d.children || []
        if d.title
          @title = d.title
        else
          @title = d.component.humanize.titleize
        end
        @component = d.component || d.title
      end
    end

    def title
      "<a href=\"\##{@component.parameterize}\">#{@title}</a>"
    end

    def to_s
      s = "<ul><li>#{title}"
      s += @children.map {|w| NavigationElt.new(w)}.join
      s += "</li></ul>"
      s
    end
  end

  class << self
    def registered(app)
      app.helpers ArrayNavigationHelpers
    end

    alias :included :registered
  end

  module ArrayNavigationHelpers
    def array_navigation(page, data)
      data.map {|d| NavigationElt.new(d)}.join
    end
  end
end

::Middleman::Extensions.register(:array_navigation, ArrayNavigation)
