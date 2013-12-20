require "active_support/concern"

module ConAir
  module Hijacker
    extend ActiveSupport::Concern

    included do
      class_attribute :handler_hijackings
      self.handler_hijackings = {}

      class << self
        alias_method_chain :connection_handler, :hijacking
      end
    end

    module ClassMethods
      def connection_handler_with_hijacking
        handler = handler_hijackings[connection_id]

        if handler && handler.active
          handler
        else
          connection_handler_without_hijacking
        end
      end
    end
  end
end
