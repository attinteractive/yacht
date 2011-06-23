When /^I use Yacht to generate a javascript snippet with environment: "([^"]*)"$/ do |env|
  in_current_dir do
    @js_snippet = Yacht::Loader.to_js_snippet(:env => env)
  end
end

Then /^the javascript snippet should contain:$/ do |string|
  @js_snippet.should == string
end
