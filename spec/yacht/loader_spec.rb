require 'spec_helper'

describe Yacht::Loader do
  subject{ Yacht::Loader }

  let(:mock_base_config) do
    {
      'default' => {
        :color_of_the_day   => 'orange',
        :super_secret_info  => 'swordfish'
      },
      'wacky' => {
        :color_of_the_day   => 'purple',
        :super_secret_info  => 'mackerel',
      }
    }
  end

  describe :dir do
  end

  describe :to_hash do
    before do
      subject.stub(:base_config).and_return(mock_base_config)
      subject.stub(:local_config).and_return({})
      subject.stub(:whitelist).and_return([:color_of_the_day])
    end

    it "returns all keys by default" do
      subject.to_hash.should  == mock_base_config['default']
    end

    it "only returns keys included in whitelist when :apply_whitelist? option is true" do
      subject.to_hash(:apply_whitelist? => true).should  == {:color_of_the_day => 'orange'}
    end

    it "allows selection of the environment by passing an :env param" do
      subject.to_hash(:env => 'wacky').should  == mock_base_config['wacky']
    end

    context "with inheritance" do
      let(:mock_base_config_with_inheritance) do
        {
          'default' => {
            :doggies   => {
              'lassie'  => 'nice',
              'cujo'    => 'mean'
            }
          },
          'papa'    => {
            :use_ssl? => false,
            :doggies  => {
              'benji'   => 'smart'
            }
          },
          'kid'     => {
            '_parent' => 'papa',
            :doggies   => {
              'cerberus'   => '3-headed'
            }
          }
        }
      end

      before do
        subject.stub(:base_config).and_return(mock_base_config_with_inheritance)
        subject.environment = 'kid'
      end

      it "transfer values from _parent environment if _parent is set" do
        subject.to_hash[:use_ssl?].should be_false
      end

      it "merges the hashes recursively" do
        subject.to_hash[:doggies].should == {
          'lassie'  => 'nice',
          'cujo'    => 'mean',
          'benji'   => 'smart',
          'cerberus'   => '3-headed'
        }
      end
    end

    context "with inheritance when a parent is missing" do
      let(:mock_base_config_with_inheritance) do
        {
          'default' => {
            :doggies   => {
              'lassie'  => 'nice',
              'cujo'    => 'mean'
            }
          },
          'kid'     => {
            '_parent' => 'deadbeat_dad',
            :doggies   => {
              'cerberus'   => '3-headed'
            }
          }
        }
      end

      before do
        subject.stub(:base_config).and_return(mock_base_config_with_inheritance)
        subject.environment = 'kid'
      end

      it "raises an error if an environment is requested whose parent doesn't exist" do
        expect {
          subject.to_hash
        }.to raise_error( Yacht::LoadError, /does not exist/)
      end
    end
  end

  describe :all do
    it "merges configuration for named environment onto defaults" do
      subject.stub(:base_config).and_return({
        'default' => {
          :color_of_the_day => 'orange',
        },
        'wacky' => {
          :color_of_the_day => 'purple',
        }
      })
      subject.stub(:local_config).and_return({})

      subject.environment = 'wacky'
      subject.to_hash[:color_of_the_day].should == 'purple'
    end

    it "returns the defaults for environments that do not exist" do
      subject.stub(:base_config).and_return({
        'default' => {
          :color_of_the_day => 'orange',
        },
        'wacky' => {
          :color_of_the_day => 'purple',
        }
      })
      subject.stub(:local_config).and_return({})

      subject.environment = 'nerdy'
      subject.to_hash.should == {:color_of_the_day => 'orange'}
    end
  end

  describe :base_config do
    it "calls load_config_file" do
      subject.should_receive(:load_config_file).with(:base).and_return('foo')

      subject.base_config
    end

    it "raises an error if load_config_file returns nil" do
      subject.stub(:load_config_file).with(:base).and_return(nil)
      expect {
        subject.base_config
      }.to raise_error(Yacht::LoadError, "Couldn't load base config")
    end
  end

  describe :local_config do
    it "calls load_config_file" do
      subject.should_receive(:load_config_file).with(:local).and_return('local_foo')

      subject.local_config
    end

    it "returns an empty hash if load_config_file returns nil" do
      subject.stub(:load_config_file).with(:local).and_return(nil)
      subject.local_config.should == {}
    end

    # Handling of empty local.yml file
    # YAML.load("")
    # => false
    it "returns an empty hash if load_config_file returns false" do
      subject.stub(:load_config_file).with(:local).and_return(false)
      subject.local_config.should == {}
    end
  end

  describe :whitelist do
    # before do
    #   subject.stub(:base_config).and_return(mock_base_config)
    #   subject.stub(:local_config).and_return({})
    #   subject.stub(:whitelist).and_return([:color_of_the_day])
    # end

    it "raises an error if load_config_file returns nil" do
      subject.stub(:load_config_file).with(:whitelist, :expect_to_load => Array).and_return(nil)

      expect {
        subject.whitelist
      }.to raise_error( Yacht::LoadError, "Couldn't load whitelist")
    end

    it "expects load_config_file to return an Array" do
      subject.should_receive(:load_config_file).with(:whitelist, :expect_to_load => Array).and_return([])

      subject.whitelist
    end
  end

  describe :config_file_for do
    it "returns the full file path for the following config files: base, local & whitelist" do
      %w(base local whitelist).each do |config_file|
        subject.should_receive(:full_file_path_for_config).with(config_file)

        subject.config_file_for(config_file)
      end
    end

    it "raises an error if the config file is not found" do
      expect {
        subject.config_file_for(:foo)
      }.to raise_error( Yacht::LoadError, "foo is not a valid config type")
    end
  end

  describe :load_config_file do
    it "loads the specified file" do
      subject.stub(:config_file_for).with(:base).and_return('base_foo')
      subject.stub(:_load_config_file).with('base_foo').and_return('base_bar')
      subject.send(:load_config_file, :base, :expect_to_load => String).should == "base_bar"
    end

    it "raises an error if opening the file leads to an exception" do
      subject.stub(:config_file_for).and_raise(StandardError.new("my_unique_error_message"))

      expect {
        subject.send(:load_config_file, "some file")
      }.to raise_error( Yacht::LoadError, %r{ERROR: loading.+my_unique_error_message} )
    end

    it "raises an error if :expect_to_load param is passed but does not match loaded object" do
      subject.stub(:config_file_for).with(:foo).and_return('foo_file')
      subject.stub(:_load_config_file).with('foo_file').and_return(Hash.new) # notice the underscore!
      expect {
        subject.send(:load_config_file, :foo, :expect_to_load => Array)
      }.to raise_error( Yacht::LoadError, "foo_file must contain Array (got Hash)" )
    end
  end

  describe :_load_config_file do
    it "returns nil if file does not exist" do
      File.stub(:exists?).with('some_file').and_return(false)
      subject.send(:_load_config_file, 'some_file').should be_nil
    end

    it "opens the file using YAML.load if the file exists" do
      File.stub(:exists?).with('some_file').and_return(true)
      File.stub(:read).with('some_file').and_return('some contents')
      YAML.should_receive(:load).with('some contents')

      subject.send(:_load_config_file, 'some_file')
    end
  end

  describe :full_file_path_for_config do
    it "raises an error if dir is blank" do
      subject.stub(:dir).and_return(nil)

      expect {
        subject.full_file_path_for_config(:base)
      }.to raise_error( Yacht::LoadError, "No directory set" )
    end

    it "returns the full path to the YAML file for the given config type" do
      subject.stub(:dir).and_return('/full/path')

      subject.full_file_path_for_config(:foo).should == '/full/path/foo.yml'
    end
  end

  context "checks environment and sets sensible defaults" do
    it "sets the environment to 'default'" do
      subject.environment.should == "default"
    end
  end
end

describe YachtLoader do
  it "should alias YachtLoader to Yacht::Loader for backwards compatibility" do
    ::YachtLoader.should == Yacht::Loader
  end
end
