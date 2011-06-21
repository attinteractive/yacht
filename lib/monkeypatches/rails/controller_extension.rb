# Generate the Yacht.js file on every request in Rails
# TODO: * make this dependent on Rails environment
#       * allow this to be configured in an initializer
#
# from: https://github.com/cloudhead/more/blob/master/lib/less/controller_extension.rb
if Rails.env.development?
  class ActionController::Base
    before_filter :generate_yacht_js_file

    def generate_yacht_js_file
      Yacht::Loader.to_js_file
    end
  end
end