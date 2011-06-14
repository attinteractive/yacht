When /^I define the constant "([^"]*)" with environment: "([^"]*)"( using a whitelist)?$/ do |constant_name, env, whitelist|
  in_current_dir do
    YachtLoader.dir = '.'
    YachtLoader.environment = env
    Object.const_set( constant_name, YachtLoader.to_classy_struct(:apply_whitelist? => whitelist ) )
  end
end


Then /^the constant "([^"]*)" should contain the following hash:$/ do |constant_name, stringified|
  hash = eval(stringified)
  Object.const_get(constant_name).to_hash.should == hash # don't forget to tack on to_hash to avoid weird errors
                                                         # TODO: make ClassyStruct more Hash-like so
                                                         # i t can be compared against hashes using `==`
end