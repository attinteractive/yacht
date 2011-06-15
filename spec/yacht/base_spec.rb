require 'spec_helper'

describe Yacht do
  subject { Yacht }

  describe :[] do
    it "should retrieve value of key from Yacht::Loader.to_hash" do
      mock_hash = {}

      Yacht::Loader.should_receive(:to_hash).and_return(mock_hash)
      mock_hash.should_receive(:[]).with(:foo)

      subject[:foo]
    end
  end
end