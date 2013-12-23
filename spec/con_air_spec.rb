require "spec_helper"

describe ConAir do
  context ".hijack" do
    class DummyHandler
      attr_accessor :active

      def initialize
        @active = true
      end
    end

    shared_examples "hijacking connection handler" do |klass|
      before do
        @spec = double
        @new_handler = DummyHandler.new
        @config = double

        allow(klass).to receive(:establish_connection)
        allow(@new_handler).to receive(:hijacked_spec).and_return(double(config: @config))
        allow(ConAir::ConnectionHandler).to receive(:new).with(klass, @spec).and_return(@new_handler)
        allow(ActiveRecord::Base::ConnectionSpecification).to receive(:new).and_return(@spec)
      end

      after do
        ActiveRecord::Base.handler_hijackings = {}
      end

      it "switches connection handler" do
        old_handler = ActiveRecord::Base.connection_handler

        ConAir.hijack(@config, klass) do
          expect(ActiveRecord::Base.connection_handler).to eq(@new_handler)
        end

        expect(ActiveRecord::Base.connection_handler).to eq(old_handler)
      end

      it "inactives new handler" do
        ConAir.hijack(@config, klass) { }

        expect(@new_handler.active).to be(false)
      end

      it "establish connection" do
        expect(klass).to receive(:establish_connection)

        ConAir.hijack(@config, klass) { }
      end

      context "when has existing hijacked connection" do
        before do
          allow(@new_handler).to receive(:exist?).and_return(true)
          ConAir.hijack(@config, klass) { }
        end

        it "sets handler's active and not creating another handler" do
          expect(@new_handler.active).to be(false)

          ConAir.hijack(@config, klass) do
            expect(@new_handler.active).to be(true)
          end
        end

        it "does not create handler" do
          expect(ConAir::ConnectionHandler).not_to receive(:new).with(klass, @spec)

          ConAir.hijack(@config, klass) { }
        end
      end

      context "when has no existing hijacked connection" do
        before do
          allow(@new_handler).to receive(:exist?).and_return(false)
          ConAir.hijack(@config, klass) { }
        end

        it "creates connection handler" do
          expect(ConAir::ConnectionHandler).to receive(:new).with(klass, @spec)

          ConAir.hijack(@config, klass) { }
        end
      end
    end

    context "when hijacking on subclass of ActiveRecord::Base" do
      it_should_behave_like "hijacking connection handler", User
    end

    context "when hijacking on ActiveRecord::Base" do
      it_should_behave_like "hijacking connection handler", ActiveRecord::Base
    end
  end
end
