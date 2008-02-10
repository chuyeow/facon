require File.dirname(__FILE__) + '/spec_helper'

describe "A mock object" do
  before do
    @mock = Facon::Mock.new('test mock')
  end

  it "should pass when not receiving message specified as not to be received" do
    @mock.should_not_receive(:not_expected)

    lambda { @mock.spec_verify }.should.not.raise(Facon::MockExpectationError)
  end

  it "should pass when receiving message specified as not to be received with different args" do
    @mock.should_not_receive(:message).with(:not_this)
    @mock.should_receive(:message).with(:but_this)
    @mock.message(:but_this)

    lambda { @mock.spec_verify }.should.not.raise(Facon::MockExpectationError)
  end

  it "should raise a MockExpectationError when receiving message specified as not to be received" do
    @mock.should_not_receive(:not_expected)
    @mock.not_expected

    lambda { @mock.spec_verify }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' expected :not_expected with (any args) 0 times, but received it 1 time" 
  end

  it "should raise a MockExpectationError when receiving message specified as not to be received with arguments" do
    @mock.should_not_receive(:not_expected).with(:unexpected_arg)
    @mock.not_expected(:unexpected_arg)

    lambda { @mock.spec_verify }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' expected :not_expected with (:unexpected_arg) 0 times, but received it 1 time"
  end

  it "should pass when receiving message specified as not to be received, but with wrong arguments" do
    @mock.should_not_receive(:not_expected).with(:unexpected_arg)
    @mock.not_expected(:wrong_arg)

    lambda { @mock.spec_verify }.should.not.raise(Facon::MockExpectationError)
  end

  it "should raise a MockExpectationError when receiving message specified as to be received is not called" do
    @mock.should_receive(:expected_message)

    lambda { @mock.spec_verify }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' expected :expected_message with (any args) 1 time, but received it 0 times"
  end

  it "should raise a MockExpectationError when receiving message specified as to be received, but with wrong arguments" do
    @mock.should_receive(:expected_message).with(:expected_arg)

    lambda {
      @mock.expected_message(:unexpected_arg)
    }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' expected :expected_message with (:expected_arg), but received it with (:unexpected_arg)"
  end

  it "should raise a MockExpectationError when receiving an unexpected message" do
    lambda {
      @mock.not_expected
    }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' received unexpected message :not_expected with (no args)"
  end
end







