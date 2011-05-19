require 'spec_helper'

describe "Rails support" do
  before do
    require "yacht_loader/rails"
    @yacht_dir = "/path/to/rails/config/yacht"
  end

  describe :environment do
    before do
      Rails = stub("Rails")
    end
    it "uses the current rails environment by default" do
      Rails.should_receive(:env)

      YachtLoader.environment
    end
  end

  describe :dir do
    it "uses config/yacht by default" do
      Rails.stub_chain(:root, :join).and_return(@yacht_dir)

      YachtLoader.dir.should == @yacht_dir
    end
  end

  describe :full_file_path_for_config do
    it "calls dir.join" do
      fake_dir = stub("dir stub")
      YachtLoader.stub(:dir).and_return(fake_dir)
      fake_dir.should_receive(:join).with("some.yml")

      YachtLoader.full_file_path_for_config("some")
    end
  end
end
