module ConAir
  class ConnectionHandler < ActiveRecord::ConnectionAdapters::ConnectionHandler
    attr_accessor :active
    attr_reader :hijacked_spec
    attr_reader :swap_class

    def initialize(swap_class, hijacked_spec, pools = {})
      super(pools)

      @hijacked_spec = hijacked_spec
      @swap_class = swap_class
      @active = true

      # Init connections after switching handler
      ActiveRecord::Base.establish_connection
    end

    def establish_connection(name, spec)
      if name == swap_class.name
        @connection_pools[@hijacked_spec] ||= ActiveRecord::ConnectionAdapters::ConnectionPool.new(@hijacked_spec)
        @class_to_pool[name] = @connection_pools[@hijacked_spec]
      else
        super
      end
    end

    def exist?(config, klass)
      hijacked_spec.config == config && swap_class == klass
    end
  end
end
