require File.dirname(__FILE__) + '/spec_helper'

# This example group/context has to come come first since we have to make sure
# that facon/baconize has not been required yet.
describe "Not requiring Facon::Baconize" do
  it "should not make the #mock instance method available to Bacon::Context" do
    Bacon::Context.public_instance_methods.should.not.include?('mock')
  end

  it "should not make the #receive instance method available to Should" do
    Should.public_instance_methods.should.not.include?('receive')
  end

  it "should fail when expectations are set with should.receive(:message)" do
    @mock = Facon::Mock.new('test mock')
    lambda {
      @mock.should.receive(:message).and_return(:foo)
    }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' received unexpected message :receive? with (:message)"
  end
end

describe "Facon::Baconize" do
  before do
    require 'facon/baconize'
    @mock = Facon::Mock.new('test mock')
  end

  it "should make the #mock instance method available to Bacon::Context" do
    Bacon::Context.public_instance_methods.should.include?('mock')
  end

  it "should make the #receive instance method available to Should" do
    Should.public_instance_methods.should.include?('receive')
  end

  it "should allow expectations on mocks with should.receive(:message)" do
    @mock.should.receive(:message).and_return(:foo)

    @mock.message.should == :foo

    lambda { @mock.spec_verify }.should.not.raise(Facon::MockExpectationError)
  end

  it "should allow expectations on mocks with should.not.receive(:message)" do
    @mock.should.not.receive(:message)

    @mock.message

    lambda { @mock.spec_verify }.should.raise(Facon::MockExpectationError).message.should == "Mock 'test mock' expected :message with (any args) 0 times, but received it 1 time"
  end

  it "should allow expectations on arbitrary objects with should.receive(:message)" do
    Object.should.receive(:message).and_return(:foo)
    @object = Object.new
    @object.should.receive(:message).and_return(:bar)

    Object.message.should == :foo
    @object.message.should == :bar

    lambda {
      Object.spec_verify
      @object.spec_verify
    }.should.not.raise(Facon::MockExpectationError)
  end
end