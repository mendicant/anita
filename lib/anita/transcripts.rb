module Anita
  class Transcripts
    extend Forwardable
    include Enumerable

    def self.record(channel, nick, text)
      Messages.create(
        timestamp: Time.now.utc.to_datetime,
        channel:   channel,
        nick:      nick,
        text:      text.encode("UTF-8", invalid: :replace, undef: :replace)
      )
    end

    def self.find(channel, from, to)
      messages = Messages.all(channel: channel, timestamp: (from..to))
      Transcripts.new(messages)
    end

    def_delegator :@messages, :each

    attr_reader :channel

    def initialize(messages)
      @messages = messages
      @channel  = messages.first.channel
    end

    def to_json
      @messages.map(&:to_h).to_json
    end
  end
end
