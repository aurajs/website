module HullHelpers

  def pluralize(count, singular, plural = nil)
    "#{count || 0} " + ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize))
  end

  def page_title page=""
    "#{data.strings.title} : #{(data.page.title||data.strings.tagline)}"
  end

  def page_type
    data.page.page_type rescue 'docs'
  end

  def description
    data.page.description ||data.strings.description
  end

  def app_name
    data.page.app_name || data.strings.title['app_name']
  end

  def tagline
    data.page.tagline || data.strings.tagline
  end

  def intro
    data.page.intro || data.strings.intro
  end

  def title
    data.page.title || data.strings.title
  end

  def docs_title page
    (page.metadata[:page]['title']||page.url.split('/').last.gsub('.html','').humanize)
  end

  def docs_tree page
    return @pages unless @pages.nil?
    return [] if page.match(/^\/docs\/?$/)
    pages = sitemap.resources.find_all {|p| p.url.match(/^#{page}.+/) }
    @pages = pages.sort_by { |o| (o.metadata[:page]['weight'] or 0)  }.reverse.group_by {|o| o.url.split('/')[2..-2].join('/') }
    @pages
  end


  def interest_groups
    @gb ||= Gibbon.new
    groupings = @gb.list_interest_groupings({:id=>ENV['MAILCHIMP_LIST_ID']})
    return nil unless groupings.is_a? Array
    groupings
  end

  def merge_tags
    @gb ||= Gibbon.new
    mt = @gb.list_merge_vars({:id=>ENV['MAILCHIMP_LIST_ID']})
    return nil unless mt.is_a? Array
    mt
  end

  def merge_class field
    f = field['field_type']
    f+=(" required") unless field['req'].nil?
    f
  end

  def merge_type field
    field['field_type']
  end
end
