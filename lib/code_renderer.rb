require_relative './highlighter'

class CodeRenderer < Redcarpet::Render::HTML
  include Highlighter::Helpers

  def block_code(code, language)
    _highlight(code, language || 'javascript')
  end
end
