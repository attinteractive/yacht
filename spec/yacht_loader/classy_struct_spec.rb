require 'spec_helper'

describe "to_classy_struct" do
  before do
    conjure_config_file_from_prefix("base")
    conjure_config_file_from_prefix("local")
    conjure_config_file_from_prefix("whitelist")

    YachtLoader.environment = 'an_environment'
  end

  it "creates a ClassyStruct based on to_hash" do
    Yacht = YachtLoader.to_classy_struct
    Yacht.dog.should == "terrier"
  end

  # ClassyStruct improves performance by adding accessors to the instance object
  # If the instance is not reused, there is no advantage to ClassyStruct over OpenStruct
  it "reuses the instance of ClassyStruct on subsequent calls" do
    first_obj = YachtLoader.classy_struct_instance
    second_obj = YachtLoader.classy_struct_instance

    first_obj.object_id.should == second_obj.object_id.should
  end

  it "passes options to to_hash" do
    YachtLoader.should_receive(:to_hash).with({:my => :awesome_option})

    Yacht = YachtLoader.to_classy_struct({:my => :awesome_option})
  end

  it "raises a custom error if ClassyStruct cannot be created" do
    YachtLoader.stub!(:to_hash).and_raise("some funky error")

    expect {
      Yacht = YachtLoader.to_classy_struct
    }.to raise_error(YachtLoader::LoadError, /some funky error/)
  end
end