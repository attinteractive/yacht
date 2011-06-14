Then /^a "([^"]*)" error with message "([^"]*)" should be raised when I try to use Yacht$/ do |error_class_name, error_message|
  klass = eval(error_class_name) # quick-n-dirty replacement for Rails' Object#constantize
  in_current_dir do
    expect {
      YachtLoader.dir = '.'
      YachtLoader.environment = 'development'
      YachtLoader.to_classy_struct
    }.to raise_error(klass, error_message)
  end
end
