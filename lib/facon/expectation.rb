require 'forwardable'

module Facon
  # An Expectation, also know as a mock method, is an expectation that an object
  # should receive a specific message during the execution of an example.
  class Expectation
    extend ::Forwardable
    def_delegators :@error_generator, :raise_expectation_error, :raise_block_failed_error

    attr_reader :error_generator, :expectation_ordering, :expected_from, :method, :method_block, :expected_received_count, :actual_received_count, :argument_expectation

    def initialize(error_generator, expectation_ordering, expected_from, method, method_block, expected_received_count = 1)
      @error_generator = error_generator
      @expectation_ordering = expectation_ordering
      @expected_from = expected_from
      @method = method
      @method_block = method_block
      @expected_received_count = expected_received_count

      @argument_expectation = :any
      @exception_to_raise = nil
      @symbol_to_throw = nil
      @actual_received_count = 0
      @args_to_yield = []
    end

    # Sets up the expected method to return the given value.
    def and_return(value)
      raise MockExpectationError, 'Ambiguous return expectation' unless @method_block.nil?

      @return_block = lambda { value }
    end

    # Sets up the expected method to yield with the given arguments.
    def and_yield(*args)
      @args_to_yield << args
      self
    end

    # Sets up the expected method to raise the given <code>exception</code>
    # (default: Exception).
    def and_raise(exception = Exception)
      @exception_to_raise = exception
    end

    # Sets up the expected method to throw the given <code>symbol</code>.
    def and_throw(sym)
      @symbol_to_throw = sym
    end

    def with(*args, &block)
      @method_block = block if block
      @argument_expectation = args
      self
    end

    def invoke(args, block)
      begin
        raise @exception_to_raise unless @exception_to_raise.nil?
        throw @symbol_to_throw unless @symbol_to_throw.nil?

        return_value = if !@method_block.nil?
          invoke_method_block(args)
        elsif @args_to_yield.size > 0
          @args_to_yield.each { |curr_args| block.call(*curr_args) }
        else
          nil
        end

        if @return_block
          args << block unless block.nil?
          @return_block.call(*args)
        else
          return_value
        end
      ensure
        @actual_received_count += 1
      end
    end

    # Returns true if this expectation has been met.
    # TODO at_least and at_most conditions
    def met?
      return true if @expected_received_count == :any ||
        @expected_received_count == @actual_received_count

      raise_expectation_error(self)
    end

    # Returns true if the given <code>method</code> and arguments match this
    # Expectation.
    def matches(method, args)
      @method == method && check_arguments(args)
    end

    # Returns true if the given <code>method</code> matches this Expectation,
    # but the given arguments don't.
    def matches_name_but_not_args(method, args)
      @method == method && !check_arguments(args)
    end

    def negative_expectation_for?(method)
      false
    end

    private
      def check_arguments(args)
        case @argument_expectation
        when :any then true
        when args then true
        end
      end

      def invoke_method_block(args)
        @method_block.call(*args)
      rescue => e
        raise_block_failed_error(@method, e.message)
      end
  end

  class NegativeExpectation < Expectation
    def initialize(error_generator, expectation_ordering, expected_from, method, method_block, expected_received_count = 0)
      super(error_generator, expectation_ordering, expected_from, method, method_block, expected_received_count)
    end

    def negative_expectation_for?(method)
      @method == method
    end
  end
end