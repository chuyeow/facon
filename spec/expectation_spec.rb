require File.dirname(__FILE__) + '/spec_helper'

describe "A mock object" do
  before do
    @mock = Facon::Mock.new('test mock')
  end

  after do
    @mock.spec_reset
  end

  def verify_mock
    lambda { @mock.spec_verify }.should.not.raise(Facon::MockExpectationError)
  end

  it "should pass when not receiving message specified as not to be received" do
    @mock.should_not_receive(:not_expected)

    verify_mock
  end

  it "should pass when receiving message specified as not to be received with different args" do
    @mock.should_not_receive(:message).with(:not_this)
    @mock.should_receive(:message).with(:but_this)
    @mock.message(:but_this)

    verify_mock
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

    verify_mock
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

  it "should raise a MockExpectationError when receiving an unexpected message with arguments" do
    lambda {
      @mock.not_expected(:foo, :bar)
    }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' received unexpected message :not_expected with (:foo, :bar)"
  end

  it "should use block for expectation if provided" do
    @mock.should_receive(:expected_message) do |a, b|
      a.should == :first
      b.should == :second
      'foo'
    end

    @mock.expected_message(:first, :second).should == 'foo'

    verify_mock
  end

  it "should use block with given arguments for expectation if provided" do
    @mock.should_receive(:expected_message).with(:expected_arg) do |arg|
      arg.should == :expected_arg
      'foo'
    end

    @mock.expected_message(:expected_arg).should == 'foo'

    verify_mock
  end

  it "should raise a MockExpectationError if block for expectation fails" do
    @mock.should_receive(:expected_message) do |arg|
      arg.should == :expected_arg
    end

    lambda {
      @mock.expected_message(:unexpected_arg)
    }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' received :expected_message but passed block failed with: :unexpected_arg.==(:expected_arg) failed"
  end

  it "should raise a MockExpectationError if there's a block for expectation and an #and_return expectation is also set" do
    lambda {
      @mock.should_receive(:foo) do
        :this
      end.and_return(:that)
    }.should.raise(Facon::MockExpectationError).message.should == 'Ambiguous return expectation'
  end
end







