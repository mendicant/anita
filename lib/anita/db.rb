module Anita
  module Storage
    DB = SQLite3::Database.new(Anita::Config::DB)
    DB.results_as_hash = true

    module Statements
      module Activities
        Load = DB.prepare(
          "SELECT description, channel, started_at, ended_at
           FROM activities
           WHERE description = :description"
        )

        Create = DB.prepare(
          "INSERT INTO activities (description, channel, started_at, ended_at)
           VALUES (:description, :channel, :started_at, :ended_at)"
        )
      end

      module Transcripts
        Save = DB.prepare(
          "INSERT INTO transcripts (timestamp, channel, nick, text)
           VALUES (:timestamp, :channel, :nick, :text)"
        )

        Load = DB.prepare(
          %{SELECT
            strftime('%Y-%m-%d %H:%M:%S UTC', timestamp)
              as "humanized-timestamp",
            timestamp, channel, nick, text
           FROM transcripts
           WHERE channel = :channel
           AND DATETIME(timestamp) BETWEEN DATETIME(:from) AND DATETIME(:to)
           ORDER BY DATETIME(timestamp) ASC}
        )
      end
    end
  end
end
