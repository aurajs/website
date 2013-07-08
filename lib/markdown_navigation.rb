module MarkdownNavigation

  class MarkdownNavigationGenerator < Redcarpet::Render::Base
    def header (txt, lvl)
      return if lvl > 2
      if lvl.to_i == 1
        el = "h3"
      elsif lvl.to_i == 2
        el = "p"
      end
      "<#{el}><a href=\"\##{txt.parameterize}\">#{txt}</a></#{el}>"
    end
  end

  class << self
    def registered(app)
      app.helpers MarkdownNavigationHelpers
    end

    alias :included :registered
  end

  module MarkdownNavigationHelpers
    def markdown_navigation(page)
      content = open(page.source_file).read 
      yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
      content = content.sub(yaml_regex, "") if content =~ yaml_regex
      Redcarpet::Markdown.new(::MarkdownNavigation::MarkdownNavigationGenerator).render content
    end
  end

end

::Middleman::Extensions.register(:markdown_navigation, MarkdownNavigation)

