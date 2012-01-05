require 'spec_helper'
require "yacht/rails"

describe Yacht::Rails do
  class SomeClass
    class << self
      attr_accessor :environment, :dir
      def all
      end
    end
  end

  class FakeRails; end

  subject { SomeClass }

  describe "when Rails does not exist" do
    it "including the module should raise an error" do
      expect{
        class SomeClass
          include Yacht::Rails
        end
      }.to raise_error ('Rails is not defined!')
    end
  end

  describe "when Rails exists" do
    before :all do
      @yacht_dir = "/path/to/rails/config/yacht"
    end

    around :each do |example|
      with_constants :Rails => FakeRails do
        Rails.stub(:env).and_return(:awesome)
        Rails.stub_chain(:root, :join).and_return(@yacht_dir)

        class SomeClass
          include Yacht::Rails
        end

        example.run
      end
    end

    describe :environment do
      it "uses the current rails environment by default" do
        subject.environment.should == :awesome
      end
    end

    describe :dir do
      it "uses config/yacht by default" do
        subject.dir.should == @yacht_dir
      end
    end

    describe :all_with_rails_env do
      it "adds the current Rails environment to super" do
        subject.stub(:all_without_rails_env).and_return(:foo => :bar)

        subject.all_with_rails_env.should == {:foo => :bar, 'rails_env' => :awesome}
      end
    end
  end
end
