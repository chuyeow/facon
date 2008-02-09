module Facon
  # A helper class for generating errors for expectation errors on mocks.
  class ErrorGenerator
    def initialize(target, name)
      @target, @name = target, name
    end
  end
end