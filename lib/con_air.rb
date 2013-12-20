require "con_air/version"
require "con_air/railtie"
require "con_air/connection_handler"

module ConAir
  def self.hijack(config, klass = ActiveRecord::Base, &block)
    ar = ActiveRecord::Base
    handler = ar.handler_hijackings[ar.connection_id]

    if handler && handler.exist?(config, klass)
      handler.active = true
    else
      spec = ActiveRecord::Base::ConnectionSpecification.new(config, klass.connection_pool.spec.adapter_method)
      ar.handler_hijackings[ar.connection_id] = ConnectionHandler.new(klass, spec)
    end

    ar.establish_connection

    yield
  ensure
    ar.handler_hijackings[ar.connection_id].active = false
  end
end
