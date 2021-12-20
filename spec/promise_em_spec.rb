# frozen_string_literal: true

RSpec.describe PromiseEm::Promise do
  context "when no deferrable objects in callbacks" do
    it "calls all then callbacks" do
      expected_data = %i[new then1 then2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          data << :then1
        end.then do
          data << :then2
        end.catch do |_error|
          data << :catch
        end
        EM::Timer.new(0.1) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end

    it "calls all catch callbacks" do
      expected_data = %i[new catch1 catch2]
      data = []
      EM.run do
        described_class.new do |_resolve, reject|
          data << :new
          reject.call
        end.then do
          data << :then
        end.catch do |_error|
          data << :catch1
        end.catch do |_error|
          data << :catch2
        end
        EM::Timer.new(0.1) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end

    it "calls then and catch callbacks" do
      expected_data = %i[new then1 then2 catch1 catch2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          data << :then1
        end.then do
          data << :then2
          raise "error"
        end.then do
          data << :then3
        end.catch do |_error|
          data << :catch1
        end.catch do |_error|
          data << :catch2
        end
        EM::Timer.new(0.1) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end

    context "when raise error" do
      it "calls all catch callbacks" do
        expected_data = %i[new then1 catch1 catch2]
        data = []
        EM.run do
          described_class.new do |resolve, _reject|
            data << :new
            resolve.call
          end.then do
            data << :then1
            raise "error"
          end.then do
            data << :then2
          end.catch do |_error|
            data << :catch1
          end.catch do |_error|
            data << :catch2
          end
          EM::Timer.new(0.1) { EM.stop }
        end
        expect(data).to eql(expected_data)
      end
    end
  end

  context "when deferrable objects in callbacks" do
    it "calls all then callbacks" do
      expected_data = %i[new then1 then2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.succeed }
          data << :then1
          defer
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.succeed }
          data << :then2
          defer
        end.catch do |_error|
          data << :catch1
        end
        EM::Timer.new(0.3) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end

    it "calls all catch callbacks" do
      expected_data = %i[new then1 catch1 catch2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.fail }
          data << :then1
          defer
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.succeed }
          data << :then2
          defer
        end.catch do |_error|
          data << :catch1
        end.catch do |_error|
          data << :catch2
        end
        EM::Timer.new(0.3) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end

    it "calls then and catch callbacks" do
      expected_data = %i[new then1 then2 catch1 catch2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.succeed }
          data << :then1
          defer
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.fail }
          data << :then2
          defer
        end.then do
          data << :then3
        end.catch do |_error|
          data << :catch1
        end.catch do |_error|
          data << :catch2
        end
        EM::Timer.new(0.3) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end
  end

  context "when deferrable and no deferrable objects in callbacks" do
    it "calls all then callbacks" do
      expected_data = %i[new then1 then2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          data << :then1
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.succeed }
          data << :then2
          defer
        end.catch do |_error|
          data << :catch1
        end
        EM::Timer.new(0.2) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end

    it "calls then and catches callbacks" do
      expected_data = %i[new then1 then2 catch1 catch2]
      data = []
      EM.run do
        described_class.new do |resolve, _reject|
          data << :new
          resolve.call
        end.then do
          defer = EM::DefaultDeferrable.new
          EM::Timer.new(0.1) { defer.succeed }
          data << :then1
          defer
        end.then do
          data << :then2
          raise "error"
        end.then do
          data << :then3
        end.catch do |_error|
          data << :catch1
        end.catch do |_error|
          data << :catch2
        end
        EM::Timer.new(0.2) { EM.stop }
      end
      expect(data).to eql(expected_data)
    end
  end
end
