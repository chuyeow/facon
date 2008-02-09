module Facon
  # A module containing convenient methods for creating mocks and stubs. 
  #
  # == Example
  #   module Bacon
  #     class Context
  #       include Facon::SpecMethods
  #     end
  #   end
  module SpecMethods
    def mock(name, stubs = {})
      Facon::Mock.new(name, stubs)
    end
  end
end