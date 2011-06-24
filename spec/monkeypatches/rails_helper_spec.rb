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

  let(:dummy_instance) {
    dummy_class.new
  }

  before do
    Rails             = stub('Rails')

    require "monkeypatches/rails_helper"

    dummy_class.send(:include, Yacht::RailsHelper)
  end

  describe :yacht_js_snippet do
    it "should use javascript_tag to create a snippet using the current Rails environment by default" do
      Yacht::Loader.stub(:to_js_snippet).and_return(mock_js_string)
      dummy_instance.should_receive(:javascript_tag).with(mock_js_string)

      dummy_instance.yacht_js_snippet
    end

    it "should pass options to Yacht::Loader#to_js_snippet" do
      dummy_instance.stub(:javascript_tag).as_null_object

      Yacht::Loader.should_receive(:to_js_snippet).with(:foo => 'bar').and_return("")

      dummy_instance.yacht_js_snippet(:foo => 'bar')
    end

    it "should add yacht_js_snippet to ApplicationHelper" do
      ApplicationHelper.should <= Yacht::RailsHelper
    end
  end
end
