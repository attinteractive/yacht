When /^I use Yacht to generate a javascript file with environment: "([^"]*)" in directory: "([^"]*)"$/ do |env, dir|
  in_current_dir do
    Yacht::Loader.to_js_file(:dir => dir, :env => env)
  end
end