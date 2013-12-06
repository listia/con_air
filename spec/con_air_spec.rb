require "spec_helper"

describe ConAir do
  it ".hijack" do
    old_connection = ActiveRecord::Base.connection
    new_connection = double

    ConAir.hijack(new_connection) do
      expect(ActiveRecord::Base.connection).to eq(new_connection)
    end

    expect(ActiveRecord::Base.connection).to eq(old_connection)
  end
end
