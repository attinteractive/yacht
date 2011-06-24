module Yacht::RailsHelper
  # Create a string with a javascript version of Yacht values intended for inclusion in an HTML page
  #
  # @note environment will be set to Rails.env by default
  #
  # @example Set custom environment
  #   yacht_js_snippet(:env => 'local_development')
  #   # => "<script type=\"text/javascript\">;var Yacht = {\"foo\":\"bar\"};</script>"
  def yacht_js_snippet(opts={})
    javascript_tag Yacht::Loader.to_js_snippet(opts)
  end
end

# TODO: use a Railtie to do this Rails-3-style
module ApplicationHelper
  include Yacht::RailsHelper
end