Then /^a "([^"]*)" error with message "([^"]*)" should be raised when I try to use Yacht( with a whitelist)?$/ do |error_class_name, error_message, whitelist|
  klass = eval(error_class_name) # quick-n-dirty replacement for Rails' Object#constantize
    expect {
      use_yacht(!!whitelist)
    }.to raise_error(klass, error_message)
end

Then /^I should not receive an error when I try to use Yacht$/ do
  expect {
    use_yacht
  }.to_not raise_error
end

module ErrorHandlingHelpers
  def use_yacht(whitelist=false)
    in_current_dir do
      YachtLoader.dir = '.'
      YachtLoader.environment = 'development'
      YachtLoader.to_classy_struct(:apply_whitelist? => whitelist)
    end
  end
end
World(ErrorHandlingHelpers)