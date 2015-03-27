require 'thread'
require 'hidden_hippo/dossier'

module HiddenHippo
  class Updator
    def initialize(queue)
      @queue = queue
    end

    def start
      return if @thread
      @thread = Thread.new do
        loop do
          update = @queue.pop

          break if update == :stop

          dossier = dossier update.mac_address

          update.fields.each do |key, value|
            dossier.public_send(key) << value
          end

          begin
          dossier.save
          rescue => e
            puts 'shit'
            p e
          end
        end
      end
    end

    def stop
      @queue << :stop
      @thread.join
    end

    private

    def dossier(mac_address)
      if Dossier.where(mac_address: mac_address).exists?
        Dossier.find mac_address
      else
        Dossier.new mac_address: mac_address
      end
    end
  end
end