module MarkdownNavigation

  class MarkdownNavigationGenerator < Redcarpet::Render::Base
    def header (txt, lvl)
      level = lvl
      @prev_lvl ||= 1
      txt = txt.split("(").first
      return if lvl.to_i > 2
      s = ""
      s += "<ul>" if lvl > @prev_lvl
      s += "</li></ul></li>" if lvl < @prev_lvl
      s += "</li>" if lvl == @prev_lvl
      s +="<li><a href=\"\##{txt.parameterize}\">#{txt}</a>"
      @prev_lvl = lvl
      s
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

