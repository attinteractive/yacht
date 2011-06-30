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
  # don't forget to tack on to_hash to avoid weird errors
  # TODO: make ClassyStruct more Hash-like so it can be compared against hashes using `==`
  stringified_hash_should_match( stringified, Object.const_get(constant_name).to_hash )
end

When /^I load Yacht with environment: "([^"]*)"$/ do |env|
  Yacht::Loader.environment = env
end

Then /^Yacht should contain the following hash:$/ do |stringified|
  in_current_dir do
    stringified_hash_should_match(stringified, Yacht::Loader.to_hash)
  end
end

module LoaderHelpers
  def stringified_hash_should_match(string, hash)
    hash_from_string = eval(string)

    in_current_dir do
      hash_from_string.should == hash
    end
  end
end
World(LoaderHelpers)