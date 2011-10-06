require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "A method stub" do
  before do
    @class = Class.new do
      def self.existing_class_method
        :original_value
      end

      def existing_instance_method
        :original_value
      end
    end
    @object = @class.new
  end

  it "should override existing methods" do
    @object.existing_instance_method.should == :original_value
    @object.stub!(:existing_instance_method).and_return(:stubbed_value)

    @object.existing_instance_method.should == :stubbed_value
  end

  it "should return the expected value given to #and_return when the stubbed method is received" do
    @object.stub!(:stubbed_method).and_return(:stubbed_value)

    @object.stubbed_method.should == :stubbed_value
  end

  it "should ignore when the stubbed method is received" do
    @object.stub!(:stubbed_method)

    lambda {
      @object.stubbed_method
    }.should.not.raise
  end

  it "should ignore when the stubbed method is received with arguments" do
    @object.stub!(:stubbed_method)

    lambda {
      @object.stubbed_method(:some_arg)
    }.should.not.raise
  end

  it "should yield the argument given to #and_yield" do
    @object.stub!(:yielding_method).and_yield(:yielded)

    yielded = nil
    @object.yielding_method { |arg| yielded = arg }

    yielded.should == :yielded
  end

  it "should yield the multiple arguments given to #and_yield" do
    @object.stub!(:yielding_method).and_yield(:first, :second)

    first_arg, second_arg = nil, nil
    @object.yielding_method { |arg1, arg2| first_arg, second_arg = arg1, arg2 }

    first_arg.should == :first
    second_arg.should == :second
  end

  it "should yield multiple times with multiple calls to #and_yield (i.e. allow chaining of #and_yield calls)" do
    @object.stub!(:yielding_method).and_yield(:one).and_yield(:two)

    yielded = []
    @object.yielding_method { |arg| yielded << arg }

    yielded.should == [:one, :two]
  end

  it "should be able to yield and return different objects (i.e. allow #and_yield and #and_return chaining)" do
    @object.stub!(:yield_and_return).and_yield(:yielded).and_return(:returned)

    yielded = nil
    @object.yield_and_return { |arg| yielded = arg }.should == :returned

    yielded.should == :yielded
  end

  it "should raise the expected exception given to #and_raise" do
    @object.stub!(:failing_method).and_raise(RuntimeError)

    lambda { @object.failing_method }.should.raise(RuntimeError)
  end

  it "should throw the expected thrown value given to #and_throw" do
    @object.stub!(:pitch).and_throw(:ball)

    lambda { @object.pitch }.should.throw(:ball)
  end

  it "should ignore when the stubbed method is never called" do
  end
end

describe "A method stub with arguments" do

  before do
    @object = Object.new
    @object.stub!(:stubbed_method).with(:expected_arg).and_return(:stubbed_value)
  end

  it "should ignore when never called" do
  end

  it "should ignore when called with expected argument" do
    @object.stubbed_method(:expected_arg)
  end

  it "should raise a NoMethodError when called with no arguments" do
    lambda { @object.stubbed_method }.should.raise(NoMethodError)
  end

  it "should raise a NoMethodError when called with some other argument" do
    lambda { @object.stubbed_method(:something_else) }.should.raise(NoMethodError)
  end

  it "should allow another stub with different arguments" do
    @object.stub!(:stubbed_method).with(:something_else).and_return(:bar)

    @object.stubbed_method(:expected_arg).should == :stubbed_value
    @object.stubbed_method(:something_else).should == :bar
  end
end
