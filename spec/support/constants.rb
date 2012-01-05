# Mock a constant within the passed block
# @example mock RAILS_ENV constant
#   it "does not allow links to be added in production environment" do
#     with_constants :RAILS_ENV => 'production' do
#       get :add, @nonexistent_link.url
#       response.should_not be_success
#     end
#   end
# @note adapted from:
#   * http://stackoverflow.com/a/7849835/457819
#   * http://digitaldumptruck.jotabout.com/?p=551
def with_constants(constants)
  @constants_to_restore = {}
  @constants_to_unset   = []

  constants.each do |name, val|
    if Object.const_defined?(name)
      @constants_to_restore[name] = Object.const_get(name)
    else
      @constants_to_unset << name
    end

    Object.const_set( name, val )
  end

  begin
    yield
  ensure
    @constants_to_restore.each do |name, val|
      Object.const_set( name, val )
    end

    @constants_to_unset.each do |name|
      Object.send(:remove_const, name)
    end
  end
end

def without_constants(constants)
  @constants_to_restore = {}

  constants.each do |name, val|
    if Object.const_defined?(name)
      @constants_to_restore[name] = Object.const_get(name)
    end

    Object.send(:remove_const, name)
  end

  begin
    yield
  ensure
    @constants_to_restore.each do |name, val|
      Object.const_set( name, val )
    end
  end
end