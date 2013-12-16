require "active_support/concern"

module ConAir
  module Hijacker
    extend ActiveSupport::Concern

    included do
      class_attribute :connection_hijackings
      self.connection_hijackings = {}

      class << self
        alias_method_chain :connection, :hijacking
      end
    end

    module ClassMethods
      def connection_with_hijacking
        connection_hijackings[connection_id] || connection_hijackings["#{self}_#{connection_id}"] || connection_without_hijacking
      end
    end
  end
end
