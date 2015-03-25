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

          dossier = Dossier.find update.mac_address

          update.fields.each do |key, value|
            dossier.public_send(key) << value
          end

          dossier.save
        end
      end
    end

    def stop
      @thread.kill if @thread
    end
  end
end