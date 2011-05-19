$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup

# ==============
# = SimpleCov! =
# ==============
require 'simplecov'
SimpleCov.start

require 'yacht'

Spec::Runner.configure do |config|
  config.after :each do
    YachtLoader.environment = nil
    YachtLoader.dir         = nil
    YachtLoader.instance_variable_set(:@config_file_names, nil)
  end
end

BASE_CONFIG_FILE = <<EOF
default:
  name: default
  defaultkey: defaultvalue
  dog: schnauzer
  hashkey:
    foo: bar
    baz: wurble
    xyzzy: thud
an_environment:
  name: an_environment
  hashkey:
    baz: yay
  dog: terrier
a_child_environment:
  _parent: an_environment
  name: a_child_environment
  hashkey:
    foo: kung
test:
  baloney: delicious
EOF

WHITELIST_CONFIG_FILE = <<EOF
- defaultkey
- hashkey
EOF

EMPTY_WHITELIST_CONFIG_FILE = <<EOF
EOF

INVALID_WHITELIST_CONFIG_FILE = <<EOF
somenonsenseorother
EOF

LOCAL_CONFIG_FILE = <<EOF
localkey: localvalue
EOF

EMPTY_LOCAL_CONFIG_FILE = <<EOF
EOF

INVALID_LOCAL_CONFIG_FILE = <<EOF
someinvalidstufforother
EOF


# ===================================
# = Helpers to mock file operations =
# ===================================
def banish_config_file_from_prefix(prefix)
  file_name = YachtLoader.config_file_for(prefix)
  banish_file(file_name)
end

# shortcut to mock config file
def conjure_config_file_from_prefix(prefix, file_contents=nil)
  file_name     = YachtLoader.config_file_for(prefix)
  file_contents ||= "#{prefix.upcase}_CONFIG_FILE".constantize

  conjure_file(file_name, file_contents)
end

def conjure_bad_config_file_from_prefix(prefix)
  file_name     = "#{prefix}_config_file"
  file_contents = file_name.upcase.constantize

  conjure_file(file_name, file_contents)
end

# mock file existence & contents
def conjure_file(file_name, file_contents)
  File.stub!(:exists?).with(file_name).and_return true
  File.stub!(:read).with(file_name).and_return file_contents
end

# mock file non-existence
def banish_file(file_name)
  File.stub!(:exists?).with(file_name).and_return(false)
  File.stub!(:read).with(file_name).and_raise Errno::ENOENT.new("No such file or directory - #{file_name}")
end

# ================================================
# = Railsy helper to turn strings into constants =
# ================================================
if !String.instance_methods.include?(:constantize)
  class String
    def constantize   # NOT as awesome as ActiveSupport::Inflector#constantize
      Object.const_get(self)
    end
  end
end