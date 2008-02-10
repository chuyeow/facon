module Facon
  module Mockable
    def stub!(method)
      mock_proxy.add_stub(caller(1)[0], method)
    end

    # TODO (this should actually be should.receive in Bacon-spirit)
    def should_receive(method, &block)
      mock_proxy.add_expectation(caller(1)[0], method, &block)
    end

    # TODO (this should actually be should.not.receive in Bacon-spirit)
    def should_not_receive(method, &block)
      mock_proxy.add_negative_expectation(caller(1)[0], method, &block)
    end

    # Verifies that the expectations set on this mock are all met, otherwise
    # raises a MockExpectationError.
    def spec_verify
      mock_proxy.verify
    end

    # Returns the mock proxy object.
    def mock_proxy
      @mock_proxy ||= Proxy.new(self, Mock === self ? @name : self.class.name)
    end
  end
end