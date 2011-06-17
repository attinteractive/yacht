Then /^Yacht should raise an error with message: "([^"]*)"$/ do |message|
  @last_yacht.class.should be(Yacht::LoadError)
  @last_yacht.message.should == message
end

When /^I try to use Yacht( with a whitelist)?$/ do |whitelist|
  @last_yacht = use_yacht(!!whitelist)
end

Then /^Yacht should not raise an error$/ do
  @last_yacht.class.should_not <= Exception
end

module ErrorHandlingHelpers
  # Try to use Yacht and return output of Yacht#to_classy_struct if no error raised
  # If an error is raised, return it instead
  def use_yacht(whitelist=false)
    in_current_dir do
      Yacht::Loader.environment = 'development'
      Yacht::Loader.to_classy_struct(:apply_whitelist? => whitelist)
    end
  rescue Exception => e
    e
  end
end
World(ErrorHandlingHelpers)