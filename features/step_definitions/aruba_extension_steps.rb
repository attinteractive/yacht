Given /^a file named "([^"]*)" does not exist$/ do |file_name|
  in_current_dir do
    FileUtils.rm(file_name) if File.file?(file_name)
  end
end

# Stock Aruba step definition doesn't recognize triple-quoted multiline strings
Then /^the file "([^"]*)" should contain:$/ do |file, exact_content|
  check_exact_file_content(file, exact_content)
end