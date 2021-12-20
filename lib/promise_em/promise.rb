# frozen_string_literal: true

module PromiseEm
  # JavaScript like promise for EventMachine library
  class Promise < ::EventMachine::DefaultDeferrable
    def initialize
      @then_callbacks = []
      @catch_callbacks = []
      context = self
      @resolve = create_resolve_proc(context)
      @reject = create_reject_proc(context)
      ::EventMachine.next_tick { yield(@resolve, @reject) } if block_given?
    end

    def then(&block)
      @then_callbacks << block
      self
    end

    def catch(&block)
      @catch_callbacks << block
      self
    end

    private

    def create_resolve_proc(context)
      proc do |*args|
        then_callback = @then_callbacks.shift
        unless then_callback
          context.succeed(*args)
          next
        end

        begin
          result = then_callback.call(*args)
          if result.is_a?(::EventMachine::Deferrable)
            result.callback { |*callback_args| @resolve.call(*callback_args) }.errback { |*error| @reject.call(*error) }
          else
            ::EventMachine.next_tick { @resolve.call(*result) }
          end
        rescue StandardError => e
          ::EventMachine.next_tick { @reject.call(*e) }
        end
      end
    end

    def create_reject_proc(context)
      proc do |*args|
        reject_callback = @catch_callbacks.shift
        unless reject_callback
          context.fail(*args)
          next
        end

        result = reject_callback.call(*args)
        if result.is_a?(::EventMachine::Deferrable)
          result.callback { |*cb_args| @reject.call(*cb_args) }.errback { |*cb_args| @reject.call(*cb_args) }
        else
          ::EventMachine.next_tick { @reject.call(result) }
        end
      end
    end
  end
end
