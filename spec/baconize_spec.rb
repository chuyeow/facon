require File.dirname(__FILE__) + '/spec_helper'

describe "Facon::Baconize" do

  before do
    @mock = Facon::Mock.new('test mock')
  end

  it "should make the #receive instance method available to Should" do
    Should.public_instance_methods.should.include?('receive')
  end

  it "should allow expectations on mocks with should.receive(:message)" do
    @mock.should.receive(:message).and_return(:foo)

    @mock.message.should == :foo
  end

  it "should allow expectations on mocks with should.not.receive(:message)" do
    @mock.should.not.receive(:message)

    @mock.to_s
    # FIXME: needs a better test on the actual error raised, but the
    # instance_eval in it() makes it hard.
  end

  it "should allow expectations on arbitrary objects with should.receive(:message)" do
    Object.should.receive(:message).and_return(:foo)
    @object = Object.new
    @object.should.receive(:message).and_return(:bar)

    Object.message.should == :foo
    @object.message.should == :bar
  end
end