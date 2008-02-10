module Facon
  module Baconize
    module ShouldExtensions
      def self.included(base)
        # Remove Facon::Mockable methods we mixed in to Object, since we don't
        # need those in the Should class.
        base.class_eval do
          instance_methods.each do |method|
            undef_method(method) if Facon::Mockable.public_instance_methods.include?(method)
          end
        end
      end

      def receive(method, &block)
        if @negated
          @object.mock_proxy.add_negative_expectation(caller(1)[0], method, &block)
        else
          @object.mock_proxy.add_expectation(caller(1)[0], method, &block)
        end
      end

      private
        def mock_proxy
          @mock_proxy ||= Proxy.new(@object, Mock === @object ? @object.name : @object.class.name)
        end
    end
  end
end

begin
  require 'rubygems'
  require 'bacon'

  Bacon::Context.class_eval { include Facon::SpecMethods }
  Should.class_eval { include Facon::Baconize::ShouldExtensions }
rescue LoadError
  puts 'Bacon is not available.'
end
