module Anita
  module Storage
    DB = SQLite3::Database.new(Anita::Config::DB)

    module Statements
      Save = DB.prepare("
               INSERT INTO transcripts (timestamp, channel, nick, text)
               VALUES (:timestamp, :channel, :nick, :text)"
             )
    end
  end
end
