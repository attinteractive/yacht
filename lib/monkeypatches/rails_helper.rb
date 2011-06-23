module Yacht::RailsHelper
  # Create a string with a javascript version of Yacht values intended for inclusion in an HTML page
  #
  # @note environment will be set to Rails.env by default
  #
  # @example Set custom environment
  #   yacht_js_snippet(:env => 'local_development')
  #   # => "<script type=\"text/javascript\">;var Yacht = {\"foo\":\"bar\"};</script>"
  def yacht_js_snippet(opts={})
    '<script type="text/javascript">'   +
      Yacht::Loader.to_js_snippet(opts) +
    '</script>'
  end
end

ApplicationHelper.send(:include, Yacht::RailsHelper)