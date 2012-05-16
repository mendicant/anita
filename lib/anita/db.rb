module Anita
  module Storage
    DB = SQLite3::Database.new(Anita::Config::DB)
    DB.results_as_hash = true

    module Statements
      Save = DB.prepare(
        "INSERT INTO transcripts (timestamp, channel, nick, text)
         VALUES (:timestamp, :channel, :nick, :text)"
      )

      Read = DB.prepare(
        "SELECT timestamp, channel, nick, text
         FROM transcripts
         WHERE channel = :channel
         AND DATETIME(timestamp) BETWEEN DATETIME(:from) AND DATETIME(:to)
         ORDER BY DATETIME(timestamp) ASC"
      )
    end
  end
end
