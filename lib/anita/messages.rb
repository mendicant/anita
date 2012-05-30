module Anita
  class Messages
    include DataMapper::Resource

    storage_names[:default] = "messages"

    property :timestamp, DateTime, key: true
    property :channel,   String,   key: true
    property :nick,      String,   key: true
    property :text,      Text,     lazy: false

    before(:create) do
      self.timestamp = Time.now.utc.to_datetime
      self.text      = encode(text)
    end

    def humanized_timestamp
      timestamp.strftime("%Y-%m-%d %H:%M:%S UTC")
    end

    def to_h
      attributes.merge(humanized_timestamp: humanized_timestamp)
    end

    private

    def encode(text)
      text.encode("UTF-8", invalid: :replace, undef: :replace)
    end
  end
end
