require 'spec_helper'

describe Yacht::Loader do
  subject{ Yacht::Loader }

  let(:mock_js_string) {
    ';var Yacht = {"foo":"bar"};'
  }

  describe :to_js_snippet do
    it "should export Yacht values to a javascript file" do
      subject.stub(:all).and_return(:foo => 'bar')
      subject.stub(:js_keys).and_return(:foo)

      subject.to_js_snippet.should == ';var Yacht = {"foo":"bar"};'
    end

    it "should only export values defined in javascript.yml" do
      subject.stub(:to_hash).and_return(:foo => 'bar', :baz => 'snafu')
      subject.stub(:js_keys).and_return(:baz)

      subject.to_js_snippet.should == ';var Yacht = {"baz":"snafu"};'
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