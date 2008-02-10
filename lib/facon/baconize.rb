module Facon
  # == Bacon integration
  #
  # To use Facon with Bacon, simply <code>require 'facon'</code>. Facon injects
  # itself into Bacon if it can find it, so all you have to do is to make sure
  # you have Bacon and Facon available on the load path.
  #
  # == Example
  #
  # In <code>spec_helper.rb</code>:
  #   require 'rubygems'
  #   require 'bacon'
  #   require 'facon'
  #
  # Simply <code>require</code> your <code>spec_helper.rb</code> in your specs and you are now
  # able to create mocks and expectations:
  #
  #   require '/path/to/spec_helper'
  #
  #   describe 'My examples' do
  #     it "should allow mocks and expectations" do
  #       @mock = mock('test mock')
  #       @mock.should.receive(:message).and_return(:foo)
  #
  #       do_something_with(@mock)
  #     end
  #   end
  module Baconize

    # Mixin intended for Bacon::Context so that it runs spec_verify on all mocks
    # after each example.
    module ContextExtensions
      def self.included(base)
        base.class_eval do
          alias_method :it_without_mock_verification, :it
          alias_method :it, :it_with_mock_verification
        end
      end

      def setup_facon_mocks
        $facon_mocks ||= []
      end

      def verify_facon_mocks
        $facon_mocks.each { |mock| mock.spec_verify }
      end

      def it_with_mock_verification(description, &block)
        setup_facon_mocks
        it_without_mock_verification(description, &block)
        verify_facon_mocks
      end
    end

    # Mixin intended for Bacon's Should class so that we can do
    # mock.should.receive(:message) and mock.should.not.receive(:message).
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

  Bacon::Context.class_eval { include Facon::Baconize::ContextExtensions }
  Should.class_eval { include Facon::Baconize::ShouldExtensions }
rescue LoadError
  puts 'Bacon is not available.'
end