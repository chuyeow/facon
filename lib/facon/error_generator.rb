module Facon
  # A helper class for generating errors for expectation errors on mocks.
  class ErrorGenerator
    def initialize(target, name)
      @target, @name = target, name
    end

    def raise_expectation_error(expectation)
      message = "#{target_name} expected :#{expectation.method} with #{format_args(*expectation.argument_expectation)} #{format_count(expectation.expected_received_count)}, but received it #{format_count(expectation.actual_received_count)}"
      raise(Facon::MockExpectationError, message)
    end

    def raise_unexpected_message_error(method, *args)
      raise(Facon::MockExpectationError, "#{target_name} received unexpected message :#{method} with #{format_args(*args)}")
    end

    def raise_unexpected_message_args_error(expectation, *args)
      message = "#{target_name} expected :#{expectation.method} with #{format_args(*expectation.argument_expectation)}, but received it with #{format_args(*args)}"
      raise(Facon::MockExpectationError, message)
    end

    def raise_block_failed_error(method, exception_message)
      message = "#{target_name} received :#{method} but passed block failed with: #{exception_message}"
      raise(Facon::MockExpectationError, message)
    end

    private
      def target_name
        @name ? "Mock '#{@name}'" : @target.inspect
      end

      def format_args(*args)
        return '(no args)' if args.empty?
        return '(any args)' if args == [:any]
        "(#{args.map { |a| a.inspect }.join(', ')})"
      end

      def format_count(count)
        count == 1 ? '1 time' : "#{count} times"
      end
  end
end