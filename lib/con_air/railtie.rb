require "rails/railtie"
require "con_air/hijacker"

module ConAir
  class Railtie < Rails::Railtie
    initializer "con_air.initialize" do |app|
      ActiveSupport.on_load(:active_record) do
        include(ConAir::Hijacker)
      end
    end
  end
end
