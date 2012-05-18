module Anita
  module Messages
    def self.load(channel, from, to)
      messages = Anita::Storage::Statements::Transcripts::Load
        .execute(
          "channel" => channel,
          "from"    => from,
          "to"      => to
        )
        .to_a

      messages.define_singleton_method(:channel) do
        channel
      end

      messages
    end

    def self.save(m)
      Anita::Storage::Statements::Transcripts::Save
        .execute(
          "timestamp" => Time.now.utc.to_datetime.to_s,
          "channel"   => m.channel.to_s,
          "nick"      => m.user.to_s,
          "text"      => m.message.encode(
                           "UTF-8", invalid: :replace, undef: :replace
                         )
        )
    end
  end
end
