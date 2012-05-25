module Anita
  class Messages
    include DataMapper::Resource

    storage_names[:default] = "messages"

    property :timestamp, DateTime, key: true
    property :channel,   String,   key: true
    property :nick,      String,   key: true
    property :text,      Text,     lazy: false

    def humanized_timestamp
      timestamp.strftime("%Y-%m-%d %H:%M:%S UTC")
    end

    def to_h
      {
        timestamp: timestamp, channel: channel, nick: nick, text: text,
        humanized_timestamp: humanized_timestamp
      }
    end
  end
end
