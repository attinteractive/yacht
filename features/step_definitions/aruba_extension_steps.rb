Given /^a file named "([^"]*)" does not exist$/ do |file_name|
  in_current_dir do
    remove_file(file_name) if File.file?(file_name)
  end
end