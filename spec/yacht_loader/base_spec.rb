require 'spec_helper'

describe YachtLoader do
  before(:each) do
    # mock existence and content of files to avoid file system in specs
    %w(base whitelist local).each do |prefix|
      conjure_config_file_from_prefix(prefix)
    end

    # stub bad config files to check error handling
    %w(empty_whitelist invalid_whitelist empty_local invalid_local).each do |baddie|
      conjure_bad_config_file_from_prefix(baddie)
    end
  end

  describe :base_config do
    it "calls load_config_file" do
      YachtLoader.should_receive(:load_config_file).with(:base).and_return('foo')

      YachtLoader.base_config
    end

    it "raises an error if load_config_file returns nil" do
      YachtLoader.stub(:load_config_file).with(:base).and_return(nil)
      expect {
        YachtLoader.base_config
      }.to raise_error(YachtLoader::LoadError, "Couldn't load base config")
    end
  end

  context "whitelist" do
    it "loads keys into an Array" do
      YachtLoader.whitelist.should == ["defaultkey", "hashkey"]
    end

    it "returns all keys by default, ignoring whitelist" do
      YachtLoader.environment = 'default'
      YachtLoader.to_hash.keys.should include("defaultkey", "hashkey")
    end

    it "only returns keys included in whitelist when :apply_whitelist? option is true" do
      YachtLoader.environment = 'default'
      YachtLoader.to_hash(:apply_whitelist? => true).keys.should  == ["defaultkey", "hashkey"]
    end

    context "config file" do
      it "raises an error if missing and whitelist is applied" do
        banish_config_file_from_prefix('whitelist')

        expect {
          YachtLoader.to_hash(:apply_whitelist? => true)
        }.to raise_error( YachtLoader::LoadError, /Couldn't load whitelist/)
      end

      it "raises an error if empty and whitelist is applied" do
        conjure_config_file_from_prefix( :whitelist, File.read('empty_whitelist_config_file') )

        expect {
          YachtLoader.to_hash(:apply_whitelist? => true)
        }.to raise_error( YachtLoader::LoadError, /whitelist.+ cannot be empty/)
      end

      it "raises an error if invalid and whitelist is applied" do
        conjure_config_file_from_prefix( :whitelist, File.read('invalid_whitelist_config_file') )

        expect {
          YachtLoader.to_hash(:apply_whitelist? => true)
        }.to raise_error( YachtLoader::LoadError, /whitelist.+ must contain Array/)
      end
    end
  end

  context "checks environment and sets sensible defaults" do
    it "sets the environment to 'default'" do
      YachtLoader.environment.should == "default"
    end

    it "allows setting the environment by passing an option to `to_hash`" do
      YachtLoader.to_hash(:env => 'a_child_environment')
      YachtLoader.environment.should == 'a_child_environment'
    end


    it "raises an error if an environment is requested that doesn't exist" do
      expect {
        YachtLoader.environment = 'nonexistent'
        YachtLoader.to_hash
      }.to raise_error( YachtLoader::LoadError, /does not exist/)
    end

    it "merges configuration for named environment onto defaults" do
      YachtLoader.environment = 'an_environment'
      YachtLoader.to_hash['defaultkey'].should == 'defaultvalue'
      YachtLoader.to_hash['name'].should == 'an_environment'
    end
  end

  context "handles child environment" do
    before do
      YachtLoader.environment = 'a_child_environment'
    end

    it "merges child onto the parent it names" do
      YachtLoader.to_hash['dog'].should == 'terrier'
    end

    it "merges the hashes recursively" do
      child = YachtLoader.to_hash['hashkey']

      child['foo'].should == 'kung'
      child['baz'].should == 'yay'
      child['xyzzy'].should == 'thud'
    end
  end

  context "handling of local config file" do
    before do
      YachtLoader.environment = 'an_environment'
    end

    it "merges values onto named environment and defaults" do
      YachtLoader.to_hash['defaultkey'].should == 'defaultvalue'
      YachtLoader.to_hash['name'].should == 'an_environment'
      YachtLoader.to_hash['localkey'].should == 'localvalue'
    end

    it "uses base config if missing" do
      banish_config_file_from_prefix('local')

      File.should_not_receive(:read).with('local_config_file')

      YachtLoader.send(:local_config).should == {}
      YachtLoader.to_hash['defaultkey'].should == 'defaultvalue'
      YachtLoader.to_hash['name'].should == 'an_environment'
    end

    it "uses base config if empty" do
      conjure_config_file_from_prefix(:local, File.read('empty_local_config_file'))

      File.should_not_receive(:read).with('local_config_file')

      YachtLoader.send(:local_config).should == {}
      YachtLoader.to_hash['defaultkey'].should == 'defaultvalue'
      YachtLoader.to_hash['name'].should == 'an_environment'
    end

    it "raises an error if invalid" do
      conjure_config_file_from_prefix( :local, File.read('invalid_local_config_file') )
      expect {
        YachtLoader.to_hash
      }.to raise_error( YachtLoader::LoadError, %r{local.yml must contain Hash})
    end
  end

  describe :config_file_for do
    it "returns the full file path for the following config files: base, local & whitelist" do
      %w(base local whitelist).each do |config_file|
        YachtLoader.should_receive(:full_file_path_for_config).with(config_file)

        YachtLoader.config_file_for(config_file)
      end
    end

    it "raises an error if the config file is not found" do
      expect {
        YachtLoader.config_file_for(:foo)
      }.to raise_error( YachtLoader::LoadError, "foo is not a valid config type")
    end
  end

  describe :load_config_file do
    it "loads the specified file" do
      conjure_config_file_from_prefix("base", "some contents")

      YachtLoader.send(:load_config_file, "base", :expect_to_load => String).should == "some contents"
    end

    it "raises an error if opening the file leads to an exception" do
      YachtLoader.stub(:config_file_for).and_raise(StandardError.new("my_unique_error_message"))

      expect {
        YachtLoader.send(:load_config_file, "some file")
      }.to raise_error( YachtLoader::LoadError, %r{ERROR: loading.+my_unique_error_message} )
    end
  end
end