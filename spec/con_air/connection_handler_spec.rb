require "spec_helper"

describe ConAir::ConnectionHandler do
  before do
    @swap_class = double(name: "Swap")
    @config = double.as_null_object
    @spec = double(config: @config)
    allow(ActiveRecord::Base).to receive(:establish_connection)
    @handler = ConAir::ConnectionHandler.new(@swap_class, @spec)
  end

  context "#new" do
    it "establishes activerecords connection" do
      expect(ActiveRecord::Base).to receive(:establish_connection)

      ConAir::ConnectionHandler.new(@swap_class, @spec)
    end

    it "is active" do
      expect(@handler.active).to be(true)
    end
  end

  context "#establish_connection" do
    context "when class matches the one we want to swap" do
      it "creates pool using passing in spec" do
        expect(ActiveRecord::ConnectionAdapters::ConnectionPool).to receive(:new).with(@spec)

        @handler.establish_connection(@swap_class.name, @original_spec)
      end
    end

    context "when class does not match the one we want to swap" do
      it "creates pool using original in spec" do
        expect(ActiveRecord::ConnectionAdapters::ConnectionPool).to receive(:new).with(@original_spec)

        @handler.establish_connection("SomeClass", @original_spec)
      end
    end
  end

  context "#exist?" do
    context "when has same config and class to swap" do
      it "returns true" do
        expect(@handler.exist?(@config, @swap_class)).to be(true)
      end
    end

    context "when has different config" do
      it "returns false" do
        expect(@handler.exist?(double, @swap_class)).to be(false)
      end
    end

    context "when has different class" do
      it "returns false" do
        expect(@handler.exist?(@config, double)).to be(false)
      end
    end
  end
end
