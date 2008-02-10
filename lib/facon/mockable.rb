module Facon
  # A module containing convenient methods for creating mocks, stubs and
  # expectations.
  module Mockable

    # Shortcut for creating a Facon::Mock instance.
    #
    # == Example
    #
    #   mock = mock('test mock', :foo => 'bar')
    #   mock.foo # => 'bar'
    def mock(name, stubs = {})
      Mock.new(name, stubs)
    end

    def stub!(method)
      mock_proxy.add_stub(caller(1)[0], method)
    end

    def should_receive(method, &block)
      mock_proxy.add_expectation(caller(1)[0], method, &block)
    end

    def should_not_receive(method, &block)
      mock_proxy.add_negative_expectation(caller(1)[0], method, &block)
    end

    # Verifies that the expectations set on this mock are all met, otherwise
    # raises a MockExpectationError.
    def spec_verify
      mock_proxy.verify
    end

    def spec_reset
      mock_proxy.reset
    end

    # Returns the mock proxy object.
    def mock_proxy
      @mock_proxy ||= Proxy.new(self, Mock === self ? @name : self.class.name)
    end
  end
end