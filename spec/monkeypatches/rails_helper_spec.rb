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
  end

  describe :yacht_js_snippet do
    it "should return a snippet inside a script tag for the current Rails environment" do
      Rails.should_receive(:env).and_return('my_awesome_env')
      Yacht::Loader.stub(:to_js_snippet).with(:env => 'my_awesome_env').and_return(mock_js_string)

      dummy_class.send(:include, Yacht::RailsHelper)
      dummy_class.new.yacht_js_snippet.should == "<script type=\"text/javascript\">;var Yacht = {\"foo\":\"bar\"};</script>"
    end

    it "should add yacht_js_snippet to ApplicationHelper" do
      ApplicationHelper.should_receive(:send).with(:include, Yacht::RailsHelper)
      load "monkeypatches/rails_helper.rb"
    end
  end
end
