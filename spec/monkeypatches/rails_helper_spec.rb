require 'spec_helper'

describe 'Yacht::RailsHelper' do
  let(:mock_js_string) {
    ';var Yacht = {"foo":"bar"};'
  }

  # need a dummy class to test out the Yacht::RailsHelper module
  let(:dummy_class) {
    class DummyClass
    end
    DummyClass
  }

  before do
    ApplicationHelper = stub('ApplicationHelper').as_null_object
    Rails             = stub('Rails')

    require "monkeypatches/rails_helper"

    dummy_class.send(:include, Yacht::RailsHelper)
  end

  describe :yacht_js_snippet do
    it "should return a snippet inside a script tag using the current Rails environment by default" do
      Yacht::Loader.stub(:to_js_snippet).and_return(mock_js_string)

      dummy_class.new.yacht_js_snippet.should == "<script type=\"text/javascript\">#{mock_js_string}</script>"
    end

    it "should pass options to Yacht::Loader#to_js_snippet" do
      Yacht::Loader.should_receive(:to_js_snippet).with(:foo => 'bar').and_return("")

      dummy_class.new.yacht_js_snippet(:foo => 'bar')
    end

    it "should add yacht_js_snippet to ApplicationHelper" do
      ApplicationHelper.should_receive(:send).with(:include, Yacht::RailsHelper)
      load "monkeypatches/rails_helper.rb"
    end
  end
end
