require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Facon::Mock" do
  before do
    @mock = Facon::Mock.new('test mock')
  end

  it "should stub out a method on a mock" do
    @mock.stub!(:stubbed_method).and_return(:stub_value)

    @mock.stubbed_method.should == :stub_value
    @mock.stubbed_method.should == :stub_value # called twice to ensure it stays
  end

  it "should stub out a method on a non-mock" do
    non_mock = Object.new
    non_mock.stub!(:stubbed_method).and_return(:stub_value)

    non_mock.stubbed_method.should == :stub_value
    non_mock.stubbed_method.should == :stub_value # called twice to ensure it stays
  end
end
