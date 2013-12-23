require "spec_helper"

describe ConAir::ConnectionHandler do
  before do
    @swap_class = double(name: "Swap")
    @config = double.as_null_object
    @spec = double(config: @config)
  end

  context "#new" do
    it "creates pool using passed-in spec" do
      handler = ConAir::ConnectionHandler.new(@swap_class, @spec)
      pool = handler.connection_pools[@spec]

      expect(pool).to be_instance_of(ActiveRecord::ConnectionAdapters::ConnectionPool)
      expect(pool.spec).to eq(@spec)
    end

    it "establishes activerecords connection" do
      expect(ActiveRecord::Base).to receive(:establish_connection)

      ConAir::ConnectionHandler.new(@swap_class, @spec)
    end
  end

  context "#exist?" do
    before do
      @handler = ConAir::ConnectionHandler.new(@swap_class, @spec)
    end

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
