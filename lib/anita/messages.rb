module Anita
  module Messages
    def self.save(m)
      Storage::Statements::Save.execute(
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
