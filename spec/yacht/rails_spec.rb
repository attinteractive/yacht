require 'spec_helper'

describe "Rails support" do
  subject { Yacht::Loader }

  before do
    Rails = stub("Rails")
    Object.stub(:alias_method_chain).as_null_object
    require "yacht/rails"
    @yacht_dir = "/path/to/rails/config/yacht"
  end

  describe :environment do
    it "uses the current rails environment by default" do
      Rails.should_receive(:env).and_return('awesome')

      subject.environment.should == 'awesome'
    end
  end

  describe :dir do
    it "uses config/yacht by default" do
      Rails.stub_chain(:root, :join).and_return(@yacht_dir)

      subject.dir.should == @yacht_dir
    end
  end

  describe :full_file_path_for_config do
    it "calls dir.join" do
      fake_dir = stub("dir stub")
      subject.stub(:dir).and_return(fake_dir)
      fake_dir.should_receive(:join).with("some.yml")

      subject.full_file_path_for_config("some")
    end
  end

  describe :all_with_rails_env do
    it "adds the current Rails environment to super" do
      subject.stub(:all_without_rails_env).and_return(:foo => :bar)

      Rails.stub(:env).and_return(:awesome)
      subject.all_with_rails_env.should == {:foo => :bar, 'rails_env' => :awesome}
    end

    it "aliases all to all_without_rails_env" do
      Object.should_receive(:alias_method_chain).with(:all, :rails_env)
      load "yacht/rails.rb"
    end
  end
end
