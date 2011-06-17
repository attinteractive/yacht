require 'spec_helper'

describe Yacht::Loader do
  subject{ Yacht::Loader }

  describe :to_js_string do
    it "should export Yacht values to a javascript file" do
      subject.stub(:all).and_return(:foo => 'bar')
      subject.stub(:js_keys).and_return(:foo)

      subject.to_js_string.should == ';var Yacht = {"foo":"bar"};'
    end

    it "should only export values defined in javascript.yml" do
      subject.stub(:to_hash).and_return(:foo => 'bar', :baz => 'snafu')
      subject.stub(:js_keys).and_return(:baz)

      subject.to_js_string.should == ';var Yacht = {"baz":"snafu"};'
    end
  end

  describe :to_js_file do
    let(:mock_js_string) {
      ';var Yacht = {"foo":"bar"};'
    }
    before do
      subject.stub(:to_js_string).and_return(mock_js_string)
    end

    it "should pass the contents of #to_js_string to #write_file" do
      subject.should_receive(:write_file).with('js_dir', 'Yacht.js', mock_js_string)

      subject.to_js_file(:dir => 'js_dir')
    end

    it "should raise an error if :dir param is not set" do
      expect {
        subject.to_js_file
      }.to raise_error(Yacht::LoadError, "Must provide :dir option")
    end

    it "should set the :dir option to 'public/javascripts' by default when Rails is defined" do
      Rails = mock('rails')
      Rails.stub_chain(:root, :join).with('public', 'javascripts').and_return('/path/to/rails/app/public/javascripts')

      subject.should_receive(:write_file).with('/path/to/rails/app/public/javascripts', 'Yacht.js', mock_js_string)

      subject.to_js_file
    end
  end

  describe :write_file do
    it "should create a directory with FileUtils.mkdir_p" do
      FileUtils.should_receive(:mkdir_p).with('some_dir')
      File.stub(:open).as_null_object

      subject.write_file('some_dir', 'name', 'contents')
    end

    it "writes a file to the given dir with the given name and contents" do
      FileUtils.stub(:mkdir_p).with('some_dir')

      # from : http://stackoverflow.com/questions/4070422/rspec-how-to-test-file-operations-and-file-content
      file = mock('file')
      File.should_receive(:open).with("some_dir/name", "w").and_yield(file)
      file.should_receive(:write).with("contents")

      subject.write_file('some_dir', 'name', 'contents')
    end
  end

  describe :js_keys do
    it "raises an error if load_config_file returns nil" do
      subject.stub(:load_config_file).with(:js_keys, :expect_to_load => Array).and_return(nil)

      expect {
        subject.js_keys
      }.to raise_error( Yacht::LoadError, "Couldn't load js_keys")
    end

    it "expects load_config_file to return an Array" do
      subject.should_receive(:load_config_file).with(:js_keys, :expect_to_load => Array).and_return([])

      subject.js_keys
    end
  end
end