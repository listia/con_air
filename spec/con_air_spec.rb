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

  it ".hijack_on" do
    old_connection = User.connection
    new_connection = double

    ConAir.hijack_on(User, new_connection) do
      expect(User.connection).to eq(new_connection)
      expect(ActiveRecord::Base.connection).not_to eq(new_connection)
    end

    expect(User.connection).to eq(old_connection)
  end
end
