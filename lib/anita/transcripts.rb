module Anita
  class Transcripts
    extend Forwardable
    include Enumerable

    def self.record(channel, nick, text)
      Messages.create(channel: channel, nick: nick, text: text)
    end

    def self.load(channel, from, to)
      messages = Messages.all(channel: channel, timestamp: (from..to))
      Transcripts.new(messages)
    end

    def_delegator :@messages, :each

    attr_reader :channel

    def initialize(messages)
      self.messages = messages
      self.channel  = messages.first.channel
    end

    def to_json
      @messages.map(&:to_h).to_json
    end

    private

    attr_writer :channel, :messages
  end
end
