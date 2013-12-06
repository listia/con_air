require "con_air/version"
require "con_air/railtie"

module ConAir
  def self.hijack(conn, &block)
    ar = ActiveRecord::Base
    ar.connection_hijackings[ar.connection_id] = conn

    yield
  ensure
    ar.connection_hijackings[ar.connection_id] = nil
  end
end
