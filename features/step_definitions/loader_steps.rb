Given /^I set Yacht's YAML directory to: "([^"]*)"$/ do |dir|
  in_current_dir do
    Yacht::Loader.dir = dir
  end
end

When /^I define the constant "([^"]*)" with environment: "([^"]*)"( using a whitelist)?$/ do |constant_name, env, whitelist|
  in_current_dir do
    Yacht::Loader.environment = env
    Object.const_set( constant_name, Yacht::Loader.to_classy_struct(:apply_whitelist? => whitelist ) )
  end
end


Then /^the constant "([^"]*)" should contain the following hash:$/ do |constant_name, stringified|
  hash = eval(stringified)
  Object.const_get(constant_name).to_hash.should == hash # don't forget to tack on to_hash to avoid weird errors
                                                         # TODO: make ClassyStruct more Hash-like so
                                                         # i t can be compared against hashes using `==`
end

When /^I load Yacht with environment: "([^"]*)"$/ do |env|
  Yacht::Loader.environment = env
end

Then /^Yacht should contain the following hash:$/ do |stringified|
  hash = eval(stringified)

  in_current_dir do
    Yacht::Loader.to_hash.should == hash
  end
end
