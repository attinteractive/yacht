require 'spec_helper'

describe Yacht::Loader do
  subject { Yacht::Loader }

  describe :classy_struct_instance do
    it "should create a new ClassyStruct" do
      ClassyStruct.should_receive(:new)
      subject.classy_struct_instance
    end
  end

  describe :to_classy_struct do
    it "creates a ClassyStruct based on to_hash" do
      subject.stub(:to_hash).and_return(:foo => 'bar')
      subject.to_classy_struct.foo.should == "bar"
    end

    # ClassyStruct improves performance by adding accessors to the instance object
    # If the instance is not reused, there is no advantage to ClassyStruct over OpenStruct
    it "reuses the instance of ClassyStruct on subsequent calls" do
      first_obj   = subject.classy_struct_instance
      second_obj  = subject.classy_struct_instance

      first_obj.object_id.should == second_obj.object_id.should
    end

    it "passes options to to_hash" do
      subject.should_receive(:to_hash).with({:my => :awesome_option})

      subject.to_classy_struct({:my => :awesome_option})
    end

    it "raises a custom error if ClassyStruct cannot be created" do
      subject.stub!(:to_hash).and_raise("some funky error")

      expect {
        subject.to_classy_struct
      }.to raise_error(Yacht::LoadError, /some funky error/)
    end

    it "does not intercept YachtLoader custom errors" do
      subject.stub!(:to_hash).and_raise Yacht::LoadError.new("custom error message")

      expect {
        subject.to_classy_struct
      }.to raise_error(Yacht::LoadError, "custom error message")
    end
  end

end

describe Yacht do
  after do
    Yacht.instance_variable_set(:@_hash, nil)
    Yacht.instance_variable_set(:@_classy_struct, nil)
  end

  context "just like a classy struct instance" do
    it "should retrieve values by key" do
      Yacht::Loader.stub(:to_hash).and_return(:foo => 'bar')

      Yacht.foo.should == 'bar'
    end

    it "should return nil for nonexistent keys" do
      Yacht::Loader.stub(:to_hash).and_return(:foo => 'bar')

      Yacht.snafu.should be_nil
    end

    it "should handles nested hashes" do
      Yacht::Loader.stub(:to_hash).and_return({:foo => {:bar => 'baz'}})

      Yacht.foo.to_hash.should  == {:bar => 'baz'}
      Yacht.foo.bar.should      == 'baz'
      Yacht.foo.fu.should       be_nil
    end
  end
end