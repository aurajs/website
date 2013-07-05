module ComponentHelpers
  def show_components(item)
    if item.is_a?(String)
      show_component(item)
    elsif item[:children]
      show_category(item)
    else
      show_component(item.component)
    end
  end

  private

  def show_component(item)
    s = <<END
<div id="#{item.parameterize}" data-hull-inspect="#{item}" data-hull-widget="dox/dox@hull">
  <i class="doc-loading"></i>
</div>
END
    s
  end

  def show_category(item)
    s = "# <a id=\"#{item.title.parameterize}\"></a>#{item.title}\n\n"
    s + item.children.map { |w| show_component(w.is_a?(String) ? w : w.component) }.join
  end
end
