When /^I use Yacht to generate a javascript file with environment: "([^"]*)"$/ do |env|
  in_current_dir do
    Yacht::Loader.dir = '.'
    Yacht::Loader.to_js_file(:env => env)
  end
end