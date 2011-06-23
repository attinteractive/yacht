module Yacht::RailsHelper
  def yacht_js_snippet
    '<script type="text/javascript">' +
      Yacht::Loader.to_js_snippet(:env => Rails.env) +
    '</script>'
  end
end

ApplicationHelper.send(:include, Yacht::RailsHelper)