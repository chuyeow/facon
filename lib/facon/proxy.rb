require 'forwardable'

module Facon
  # A proxy for mock objects. Stubs and expectations are set on this proxy.
  class Proxy
    extend ::Forwardable
    def_delegators :@error_generator, :raise_unexpected_message_error, :raise_unexpected_message_args_error
  
    def initialize(target, name)
      @target, @name = target, name
      @expectations = []
      @stubs = []
      @error_generator = ErrorGenerator.new(target, name)
    end

    def add_stub(expected_from, method)
      define_expected_method(method)

      # A stub is really an expectation that can be called any number of times.
      @stubs.unshift(Expectation.new(@error_generator, @expectation_ordering, expected_from, method, nil, :any))
      @stubs.first
    end

    def add_expectation(expected_from, method, &block)
      define_expected_method(method)

      @expectations << Expectation.new(@error_generator, @expectation_ordering, expected_from, method, (block_given? ? block : nil), 1)
      @expectations.last
    end

    def add_negative_expectation(expected_from, method, &block)
      define_expected_method(method)

      @expectations << NegativeExpectation.new(@error_generator, @expectation_ordering, expected_from, method, (block_given? ? block : nil))
      @expectations.last
    end

    def message_received(method, *args, &block)
      if expectation = find_matching_expectation(method, *args)
        expectation.invoke(args, block)
      elsif stub = find_matching_method_stub(method, *args)
        stub.invoke([], block)
      elsif expectation = find_almost_matching_expectation(method, *args)
        raise_unexpected_message_args_error(expectation, *args) unless has_negative_expectation?(method)
      else
        @target.send(:method_missing, method, *args, &block)
      end
    end

    def verify
      @expectations.each { |expectation| expectation.met? }
    end

    private
      # Defines an expected method that simply calls the
      # <code>message_received method</code>.
      def define_expected_method(method)
        metaclass_eval(<<-EOF, __FILE__, __LINE__)
          def #{method}(*args, &block)
            mock_proxy.message_received(:#{method}, *args, &block)
          end
        EOF
      end

      def metaclass
        (class << @target; self; end)
      end

      def metaclass_eval(str, filename, lineno)
        metaclass.class_eval(str, filename, lineno)
      end

      def find_matching_expectation(method, *args)
        @expectations.find { |expectation| expectation.matches(method, args) }
      end

      def find_almost_matching_expectation(method, *args)
        @expectations.find { |expectation| expectation.matches_name_but_not_args(method, args) }
      end

      def find_matching_method_stub(method, *args)
        @stubs.find { |stub| stub.matches(method, args) }
      end

      def has_negative_expectation?(method)
        @expectations.find { |expectation| expectation.negative_expectation_for?(method) }
      end
  end
end